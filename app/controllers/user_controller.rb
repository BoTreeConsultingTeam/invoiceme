class UserController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.where.not(id: current_user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.admin_id = current_user.id if current_user.role == "Admin"
    if @user.save
      flash[:notice] = "Successfully created User."
      redirect_to user_index_path
    else
      flash[:error] = @user.errors.full_messages.join(', ')
      render action: 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:notice] = "Successfully updated User."
      redirect_to user_index_path
    else
      flash[:error] = @user.errors.full_messages.join(', ')
      render action: 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to user_index_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :role)
  end

end
