class ClientsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  before_filter :check_authorized_access, except: [:index, :new]
 
  def index
    @clients = Client.where(company_id: current_user.company_id)
  end

  def new
    @client = Client.new
    @address = Address.new
    @client.address = @address
  end

  def create
    @client = Client.new(client_params)
    @client.company_id = current_user.company_id    
    @address = @client.address
    if @client.save      
      flash[:success] = 'Client and address saved properly'   
      redirect_to clients_path      
    else
      flash[:error] = "Client has some problem in save. #{@client.errors.full_messages.join(',')}"
      render :action => 'new'
    end
  end

  def edit
    @address = @client.address
  end

  def update
    @client.attributes = client_params
    @client.company_id = current_user.company_id
    @address = @client.address
    if @client.save
      flash[:success] = 'Client and address updated properly'
      redirect_to clients_path
    else
      flash[:error] = "Client has some problem in save. #{@client.errors.full_messages.join(',')}"      
      render :action => 'edit'
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path
  end

  private

  def client_params
    params.require(:client).permit(:name,:currency_code,address_attributes: [:street_1,:street_2,:city,:state,:pincode,:country_code])
  end

  def address_params
    params.require(:address).permit(:street_1,:street_2,:city,:state,:pincode,:country_code)
  end

  def check_authorized_access
    raise CanCan::AccessDenied.new("Unauthorized access!", :read, Client) unless ((@client.company_id == current_user.company_id))
  end
end
