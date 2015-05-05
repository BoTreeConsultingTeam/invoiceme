class CompaniesController < ApplicationController

  before_action :authenticate_user!

  def create
    @company = Company.new(company_params)
    if @company.save
      @users = User.where("admin_id = ?",current_user.id).update_all(company_id: @company.id)
      flash[:success] = "Company created successfully"
    else
      flash[:error] = "Company not saved because: #{@company.errors.full_messages.join(',')}"
    end
  end

  def update
    @company = Company.find(params[:id].to_i)
    @company.attributes = company_params
    if @company.save
      flash[:success] = "Company updated successfully"
    else
      flash[:error] = "Company not updated because: #{@company.errors.full_messages.join(',')}"
    end
  end

  protected

  def company_params
    params.require(:company).permit(:name)
  end

end
