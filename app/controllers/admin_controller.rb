class AdminController < ApplicationController
  admin_username = ENV['ADMIN_USERNAME'] || Settings.admin_username
  admin_password = ENV['ADMIN_PASSWORD'] || Settings.admin_password
  USERS = {admin_username => admin_password}
  
  before_action :authenticate

  def donations
  end

  private
    def authenticate
      authenticate_or_request_with_http_digest do |username|
        USERS[username]
      end
    end
end