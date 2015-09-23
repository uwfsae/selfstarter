AmazonFlexPay.access_key = ENV['AMAZON_ACCESS_KEY'] || Settings.amazon_access_key
AmazonFlexPay.secret_key = ENV['AMAZON_SECRET_KEY'] || Settings.amazon_secret_key
AmazonFlexPay.go_live! if Rails.env.development?