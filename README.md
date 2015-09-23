## Selfstarter ##
The main things that are modified here in this code as opposed to the original selfstarter code are following.

Color changes in stylesheets, image changes, text changes in app/views.

Changes to app/controllers/preorder_controller to grab different user and donation amount information from text fields. Added the call to AmazonFlexPay.pay. Changed from multi use tokens to single use tokens.

Changes to javascript: disabled disabling of button before filling out email because it only worked on Chrome.

Added support for stripe payments in addition to amazon payments. This
is configurable via selfstarter/config/settings.yml.

### Changing settings ###

Most settings are modifiable in config/settings.yml.

To change text on the homepage, modify the HTML files in
app/views/preorder/homepage

### Running Selfstarter on Heroku ###

Heroku is the preferred way to host the website. Set up a heroku app, then install the heroku toolbelt on your computer. After pushing the repository to heroku (using the selfstarter folder as the root of the git project), run ``` heroku run
rake db:migrate ``` and ``` heroku run rake db:seed ``` to set up the sql database. After this the app should be running unless something has gone wrong.

Author: Jeff Pyke

Updated 2/24/2015
