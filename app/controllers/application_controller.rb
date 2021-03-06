class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_company
  include ApplicationHelper

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  def is_admin?
    current_user.present? && current_user.role == "Admin"
  end

  def user_error_messages
    flash[:error] = @user.errors.full_messages.join(', ')
  end


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
