class UserController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_filter :check_authorized_access, except: [:new, :create]

  def index
    @users = current_user.colleagues
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if current_user.company.present?
      @user.company = current_user.company
    end
    if @user.save
      flash[:notice] = "Successfully created User."
      redirect_to user_index_path
    else
      add_flash_messages(@user)
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = t('users.messages.update_user')
      redirect_to user_index_path
    else
      add_flash_messages(@user)
      render :edit
    end
  end

  def show
  end

  def update_password
    params.require(:user).permit(:current_password, :password, :password_confirmation)
    if current_user.update_with_password(user_params)
      flash[:notice] = t('users.messages.update_user')
      redirect_to root_path
    else
      add_flash_messages(current_user)
      render :change_password
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to user_index_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :role, :current_password)
  end

  def check_authorized_access
    raise CanCan::AccessDenied.new("Unauthorized access!", :read, User) unless (current_user.admin? && current_user.company.present?)
  end

end
