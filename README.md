## Selfstarter ##
The main things that are modified here in this code as opposed to the original selfstarter code are following.

Color changes in stylesheets, image changes, text changes in app/views.

Changes to app/controllers/preorder_controller to grab different user and donation amount information from text fields. Added the call to AmazonFlexPay.pay. Changed from multi use tokens to single use tokens.

Changes to javascript: disabled disabling of button before filling out email because it only worked on Chrome.

Added support for stripe payments in addition to amazon payments. This
is configurable via selfstarter/config/settings.yml.

## Getting Started

*Note: This assumes you have Ruby 1.9.2 or later installed properly and have a basic working knowledge of how to use RubyGems*

First you'll need to fork and clone this repo

```bash
git clone https://github.com/lockitron/selfstarter.git
```

Let's get all our dependencies setup:
```bash
bundle install --without production
```

Now let's create the database:
```bash
rake db:migrate
```

If you're using the payment options component (use_payment_options = true in settings.yml) then need to seed some data for the options:
```bash
rake db:seed
```

Let's get it running:
```bash
rails s
```

### Customizing

While it is *just* a skeleton, we did make it a little quicker to change around things like your product name, the colors, pricing, etc.

To change around the product name, tweet text, and more, open this file:

```
config/settings.yml
```

To change around the colors and fonts, open this file:

```
app/assets/stylesheets/variables.css.scss
```

To change text on the homepage, open this file:

```
app/views/preorder/homepage
```

To dive into the code, open this file:

```
app/controllers/preorder_controller.rb
```

### Deploying to Production

We recommend using Heroku, and we even include a ```Procfile``` for you. All you need to do is first install the [Heroku Toolbelt](https://toolbelt.heroku.com) and then run:

```bash
heroku create
git push heroku master
heroku run rake db:migrate
heroku run rake db:seed
heroku open
```

UWFSAE currently uses a heroku app called uwformulaselfstarter.

Author: Jeff Pyke

Updated 2/24/2015
