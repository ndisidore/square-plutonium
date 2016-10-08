module Admin
  class BaseController < ApplicationController

    private

    helper_method :current_user, :user_signed_in?, :client_id, :set_clients

    def current_user
      return nil if session[:user_guid].blank?
      @current_user ||= User.find_by(google_uid: session[:user_guid])
    end

    def user_signed_in?
      current_user.present?
    end

    def authenticate_user!
      return if user_signed_in?
      redirect_to login_url, alert: 'You need to sign in to access this page.'
    end
    def ssl_configured?
      !(Rails.env.development? || Rails.env.test?)
    end
  end
end
