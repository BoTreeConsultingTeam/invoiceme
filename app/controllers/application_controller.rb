class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_company
  include ApplicationHelper
  
  protected

  # Allow parameters for sign up
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :admin_id, :role) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :current_password) }
  end

  def set_company  
    if is_admin?
      @company = current_user.company
      if @company.present?
      else
        @company = Company.new
      end
    else
      @company = Company.new
    end
  end

end
