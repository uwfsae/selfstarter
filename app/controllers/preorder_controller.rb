class PreorderController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => :ipn

  if Settings.payment_processor == "stripe"
    require "stripe"
    Stripe.api_key = ENV['STRIPE_API_KEY'] || Settings.stripe_api_key
  end

  def index
  end

  def checkout
  end

  def prefill
    begin
      @user = User.find_or_create_by(:email => params[:email])

      if Settings.use_payment_options
        payment_option_id = params['payment_option']
        raise Exception.new("No payment option was selected") if payment_option_id.nil?
        payment_option = PaymentOption.find(payment_option_id)
        price = payment_option.amount
      else
        raise Exception.new("No donation amount entered") if params[:amount] == "0"
        price = params[:amount].gsub('$', '')
        price = price.to_f.round(2)
      end

      @order = Order.prefill!(:name => params[:name], :price => price, :user_id => @user.id, :payment_option => payment_option)
    rescue => e
      puts e
      flash[:error] = "Sorry, there was an issue while saving the information you entered. Your card was not charged."
      redirect_to root_url
    end

    # This is where we process the credit card
    if Settings.payment_processor == "stripe"
      # For stripe payments, we process the payment immediately (no callback needed)
      client = Stripe::Customer.create(
        :email => params[:email]
      )
      card = client.sources.create(:card => params[:stripe_token])
      client.default_source = card.id

      begin
        charge = Stripe::Charge.create(
          :amount => (price * 100).to_i,
          :currency => "usd",
          :customer => client.id,
          :description => Settings.payment_description
        )
        raise Exception.new("Couldn't charge Card. Please try again") unless charge.paid
        options = {
          :callerReference => @order.uuid,
          :tokenID => charge.id,
          :addressLine1 => params[:addressLine1],
          :addressLine2 => params[:addressLine2],
          :city => params[:city],
          :state => params[:state],
          :zip => params[:zip],
          :status => "paid",
          :country => params[:tshirt]
        }
        # TODO store tshirt size in country for now, so we don't have to do a migration
        @order = Order.postfill!(options)
        flash[:alert] = "Thanks! Your payment processed successfully."
        redirect_to :action => :share, :uuid => @order.uuid
      rescue => e
        puts e
        flash[:error] = "Sorry, something went wrong. Your card couldn't be charged."
        redirect_to root_url
      end
    else
      # This is where all the magic happens. We create a multi-use token with Amazon, letting us charge the user's Amazon account
      # Then, if they confirm the payment, Amazon POSTs us their shipping details and phone number
      # From there, we save it, and voila, we got ourselves a preorder!
      port = Rails.env.production? ? "" : ":3000"
      callback_url = "#{request.scheme}://#{request.host}#{port}/preorder/postfill"
      redirect_to AmazonFlexPay.single_use_pipeline(@order.uuid, callback_url,
                                                   :transaction_amount => price,
                                                   :collect_shipping_address => "True",
                                                   :payment_reason => Settings.payment_description)
    end
  end

  def postfill
    # Callback used by Amazon Payments, but not by Stripe
    unless params[:callerReference].blank?
      @order = Order.postfill!(params)
    end
    # "A" means the user cancelled the preorder before clicking "Confirm" on Amazon Payments.
    if params['status'] != 'A' && @order.present?
      begin
        #puts @order
        #puts @order.class
        response = AmazonFlexPay.pay(@order.price, 'USD', params['tokenID'], params['callerReference'])
        flash[:alert] = "Thanks! Your payment is processing."
      rescue AmazonFlexPay::API::Error => e
        flash[:error] = "Sorry, something went wrong."
        e.errors.each do |error|
          # notify yourself about error.code and error.message
        end
      end
      redirect_to :action => :share, :uuid => @order.uuid
    else
      redirect_to root_url
    end
  end

  def share
    @order = Order.find_by(:uuid => params[:uuid])
  end

  def ipn
  end
end
