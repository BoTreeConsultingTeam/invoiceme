class UserController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_filter :check_authorized_access, except: [:index, :new, :create]

  def index
    @users = User.where("admin_id = ? and id not in (?) and role not in (?)",current_user.id,current_user.id, "Admin")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.admin_id = current_user.id if is_admin?
    if @user.save
      flash[:notice] = "Successfully created User."
      redirect_to user_index_path
    else
      user_error_messages
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "Successfully updated User."
      redirect_to user_index_path
    else
      user_error_messages
      render action: 'edit'
    end
  end

  def show
  end

  def destroy
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to user_index_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :role)
  end

  def check_authorized_access
    raise CanCan::AccessDenied.new("Unauthorized access!", :read, User) unless ((@user.admin_id == current_user.id) && (@user.id != current_user.id) && (@user.role != "Admin"))
  end

end
