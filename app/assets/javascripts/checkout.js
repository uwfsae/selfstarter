$(document).ready(function () {
  var _this;
  var handler = StripeCheckout.configure({
    key: STRIPE_PUBLIC_KEY,
    image: '/assets/uw_logo.jpg',
    token: function(token) {
      // Use the token to create the charge with a server-side script.
      // You can access the token ID with `token.id`
      $('#stripe_token').val(token.id);
      console.log('stripe token added');
      _this.submit();
    }
  });

  $('#checkout').submit(function (e) {
    e.preventDefault ? e.preventDefault() : e.returnValue = false;
    $('#payment_errors').hide();
    _this = this;
    var amount = parseFloat($('#amount').val().replace("$", ""));
    // Check that amount is a number
    if (!(amount > 0)) {
      $('#payment_errors').show();
    } else {
      // Prompt them with Stripe
      handler.open({
        name: 'SAE International',
        description: 'Donation to UW Formula Motorsports',
        amount: parseInt(amount * 100)
      });
    }
  });

  $(window).on('popstate', function() {
    handler.close();
  });
});