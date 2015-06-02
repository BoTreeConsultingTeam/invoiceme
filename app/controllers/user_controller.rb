class UserController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_filter :check_authorized_access, except: [:new, :create]
  before_filter :user_change_password_params, only: :update_change_password

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
      render action: 'new'
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
      render action: 'edit'
    end
  end

  def show
  end

  def update_change_password
    if current_user.password == params[:user][:current_password]
      if params[:user][:password] == params[:user][:password_confirmation]
        current_user.password = params[:user][:password]
        if(current_user.save)
          flash[:notice] = t('users.messages.update_user')
          redirect_to root_path
        else
          add_flash_messages(current_user)
          render action: 'change_password'
        end
      else
        flash[:error] = t('users.errors.messages.confirm_password')
        render action: 'change_password'
      end
    else
      flash[:error] = t('users.errors.messages.current_password')
      render action: 'change_password'
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to user_index_path
    end
  end

  private

  def user_change_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :role)
  end

  def check_authorized_access
    raise CanCan::AccessDenied.new("Unauthorized access!", :read, User) unless (current_user.admin? && current_user.company.present?)
  end

end
