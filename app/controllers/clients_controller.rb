class ClientsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  before_filter :check_authorized_access, except: [:index, :new, :create, :get_address]
 
  def index
    if current_user.company.present?
      @clients = current_user.company.clients
    end
  end

  def new
    @client = Client.new
    @client.address = Address.new
    @client.contact_details << ContactDetail.new
  end

  def create
    @client = Client.new(client_params)
    @client.company = current_user.company
    if @client.save      
      flash[:success] = 'Client saved successfully.'   
      redirect_to clients_path      
    else
      flash[:error] = "Problem while saving client details. #{add_flash_messages(@client)}"
      render :action => 'new'
    end
  end

  def edit
    @address = @client.address
  end

  def update
    if @client.update(client_params)
      flash[:success] = 'Client saved successfully.'
      redirect_to clients_path
    else
      flash[:error] = "Problem while saving client details. #{add_flash_messages(@client)}"
      render :action => 'edit'
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path
  end

  def address
    render :json => @client.address
  end

  private

  def client_params
    params.require(:client).permit(
      :name,:currency_code,
      address_attributes: [:street_1,:street_2,:city,:state,:pincode,:country_code, :id],
      contact_detail_ids: [], 
      contact_details_attributes: [:email, :first_name, :last_name, :phone, :mobile, :id])
  end

  def check_authorized_access
    raise CanCan::AccessDenied.new("Unauthorized access!", :read, Client) unless ((@client.company_id == current_user.company_id))
  end
end
