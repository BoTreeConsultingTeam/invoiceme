class ClientsController < ApplicationController
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
