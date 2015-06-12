class TaxesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_filter :check_authorized_access, except: [:index, :new, :create]

  def index
    @taxes = Tax.all
  end

  def new
    @tax = Tax.new
  end

  def edit
    render :new
  end

  def create
    @tax = Tax.new(tax_params)
    if @tax.save
      flash[:success] = 'Tax created successfully'
      redirect_to taxes_path
    else
      flash[:error] = add_flash_messages(@tax)
      render :new
    end
  end

  def update
    if @tax.update(tax_params)
      flash[:success] = 'Tax updated successfully'
      redirect_to taxes_path
    else
      flash[:error] = add_flash_messages(@tax)
      render :edit
    end

  end

  def destroy
    if @tax.destroy
      flash[:success] = 'Tax deleted successfully'
    else
      flash[:error] = add_flash_messages(@tax)
    end
    redirect_to taxes_path
  end

  private

  def tax_params
    params.require(:tax).permit(:name, :description, :rate, :parent_id)
  end

  def check_authorized_access
    raise CanCan::AccessDenied.new('Unauthorized access!', :read, Tax) unless current_user.admin?
  end
end
