class ClientsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  before_filter :check_authorized_access, except: [:index, :new]
 
  def index
    @clients = Client.where("company_id = ?",current_user.company_id)
  end

  def new
    @client = Client.new
    @address = @client.address
    if @address.present?
    else
      @address = Address.new
    end
  end

  def create
    @client = Client.new(client_params)
    @client.company_id = current_user.company_id
    @address = Address.new(address_params)
    if @client.save
      @address.client = @client
      if @address.save
        flash[:success] = 'Client and address saved properly'   
        redirect_to clients_path
      else
        flash[:error] = "Address has some problem in save. #{@address.errors.full_messages.join(',')}"       
        @client.destroy
        render :action => 'new'
      end
    else
      flash[:error] = "Client has some problem in save. #{@client.errors.full_messages.join(',')}"
      render :action => 'new'
    end
  end

  def edit
    @address = @client.address
  end

  def update
    @address = Address.find(params[:address_id])
    @client.attributes = client_params
    @client.company_id = current_user.company_id
    if @client.save
      @address.attributes = address_params
      if @address.save
        flash[:success] = 'Client and address updated properly'
        redirect_to clients_path
      else
        flash[:error] = "Address has some problem in save. #{@address.errors.full_messages.join(',')}" 
        render :action => 'edit'
      end
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
    params.require(:client).permit(:name,:currency_code)
  end

  def address_params
    params.require(:address).permit(:street_1,:street_2,:city,:state,:pincode,:country_code)
  end

  def check_authorized_access
    raise CanCan::AccessDenied.new("Unauthorized access!", :read, Client) unless ((@client.company_id != current_user.company_id))
  end
end
