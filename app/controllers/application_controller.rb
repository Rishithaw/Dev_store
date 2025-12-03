class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  layout "application"

  before_action :track_visits
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user, :user_signed_in?, :current_cart

  def track_visits
    session[:visits] ||= 0
    session[:visits] += 1
  end

  protected

  def configure_permitted_parameters
    added_attrs = [
      :username, :shipping_street, :shipping_city,
      :shipping_province_id, :shipping_postal_code,
      :email, :password, :password_confirmation
    ]

    devise_parameter_sanitizer.permit(:sign_up,        keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def current_cart
    session[:cart] ||= {}
  end
end
