class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_user, :user_signed_in?

  before_action :configure_permitted_parameters, if: :devise_controller?
  layout "application"

  before_action :track_visits

  def track_visits
    session[:visits] ||= 0
    session[:visits] += 1
  end


  protected

  def configure_permitted_parameters
    added_attrs = [
      :username, :shipping_street, :shipping_city, :shipping_province_id, :shipping_postal_code, :email, :password, :password_confirmation
    ]

    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
