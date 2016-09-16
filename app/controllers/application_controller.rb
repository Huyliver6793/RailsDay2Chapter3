class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :reset_session
  skip_before_action :verify_authenticity_token
  include SessionsHelper

private
  def logged_user
      unless logged_in?
        store_location
        flash[:danger] = "Mời bạn đăng nhập!"
        redirect_to login_url
      end
    end
end
