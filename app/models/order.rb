class Order < ActiveRecord::Base
  before_validation :generate_uuid!, :on => :create
  belongs_to :user
  belongs_to :payment_option
  scope :completed, -> { where("(token != ? OR token != ?) AND created_at > ?", "", nil, DateTime.new(2016, 1, 1)) }
  self.primary_key = 'uuid'

  # This is where we create our Caller Reference for Amazon Payments, and prefill some other information.
  def self.prefill!(options = {})
    @order                = Order.new
    @order.name           = options[:name]
    @order.user_id        = options[:user_id]
    @order.price          = options[:price]
    @order.number         = Order.next_order_number
    @order.payment_option = options[:payment_option] if !options[:payment_option].nil?
    @order.save!

    @order
  end

  # After authenticating with Amazon, we get the rest of the details
  def self.postfill!(options = {})
    @order = Order.find_by!(:uuid => options[:callerReference])
    @order.token             = options[:tokenID]
    if @order.token.present?
      if options[:addressLine1].to_s.strip.length != 0
        @order.address_one     = options[:addressLine1]
        @order.address_two     = options[:addressLine2]
        @order.city            = options[:city]
        @order.state           = options[:state]
        @order.zip             = options[:zip]
      end
      @order.country         = options[:country]
      @order.status          = options[:status]
      @order.phone           = options[:phoneNumber]
      @order.expiration      = Date.parse(options[:expiry]) if !options[:expiry].nil?
      @order.save!

      @order
    end
  end

  def self.next_order_number
    Order.count(:token).to_i + 1
  end

  def generate_uuid!
    begin
      self.uuid = SecureRandom.hex(16)
    end while Order.find_by(:uuid => self.uuid).present?
  end

  # goal is a dollar amount, not a number of backers, beause you may be using the multiple payment options component
  # by setting Settings.use_payment_options == true
  def self.goal
    Settings.project_goal
  end

  def self.percent
    (Order.revenue.to_f / Order.goal.to_f) * 100.to_f
  end

  # See what it looks like when you have some backers! Drop in a number instead of Order.count
  def self.backers
    Order.completed.count
  end

  def self.revenue
    if Settings.use_payment_options
      PaymentOption.joins(:orders).where("token != ? OR token != ?", "", nil).pluck('sum(amount)')[0].to_f
    else
      Order.completed.sum(:price).to_f
    end
  end

  def self.completed_with_email
    Order.completed.joins(:user).select("orders.number, orders.name, orders.price, orders.created_at, orders.address_one, orders.address_two, orders.city, orders.state, orders.zip, orders.country, users.email").order("orders.created_at ASC")
  end

  validates_presence_of :name, :price, :user_id
end
