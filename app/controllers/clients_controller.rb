class ClientsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @clients = Client.all
  end

  def new
    @client = Client.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
