class CompaniesController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  before_filter :check_authorized_access, except: [:index, :new, :create]

  def index
    unless current_user.company.present?
      redirect_to new_company_path
    else
      @company = current_user.company
    end
  end

  def new
    @company = Company.new
    @company.address = Address.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      current_user.company = @company
      current_user.save
      flash[:success] = "Company created successfully"
      redirect_to companies_path
    else
      flash[:error] = "Company not saved because: #{add_flash_messages(@company)}"
      render :new
    end   
  end

  def update
    @company = Company.find(params[:id])
    if(@company.update(company_params))
      flash[:success] = "Company updated successfully"
      redirect_to companies_path
    else
      flash[:error] = "Company not updated because: #{add_flash_messages(@company)}"
      render :edit
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, address_attributes: [:street_1,:street_2,:city,:state,:pincode,:country_code, :id])
  end

  def check_authorized_access
    raise CanCan::AccessDenied.new("Unauthorized access!", :read, Company) unless current_user.admin?
  end

end
