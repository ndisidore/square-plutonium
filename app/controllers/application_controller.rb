class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_action :set_p3p, :set_strict_transport_security
  force_ssl if: :ssl_configured?

  private

  def ssl_configured?
    !(Rails.env.development? || Rails.env.test? || bad_host?)
  end

  def set_p3p
    response.headers['CP'] = "CURa ADMa DEVa TAIi PSAi PSDi IVAi IVDi CONi HISa TELi OUR IND DSP CAO COR"
  end

  def set_strict_transport_security
    response.headers['Strict-Transport-Security'] = "max-age=31536000; includeSubDomains" if ssl_configured?
  end
end
