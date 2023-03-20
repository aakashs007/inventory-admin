class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery

  def access_denied(exception)
    redirect_to admin_dashboard_path
  end

  def set_locale
    I18n.locale = params[:language] || I18n.default_locale
  end
end