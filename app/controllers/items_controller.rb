class ItemsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def edit

  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash.clear
      flash[:success] = "Item created successfully"
    else
      flash.clear
      flash[:error] = "Item not saved because: #{@item.errors.full_messages.join(',')}"
    end
  end

  def update
    if @item.update(item_params)
      flash.clear
      flash[:success] = "Item updated successfully"
    else
      flash.clear
      flash[:error] = "Item not updated because: #{@item.errors.full_messages.join(',')}"
    end
  end

  def destroy
    if @item.destroy
      flash[:success] = "Item deleted successfully"
    else
      flash[:error] = "Item not deleted because: #{@item.errors.full_messages.join(',')}"
    end
    redirect_to items_path
  end

  protected

  def item_params
    params.require(:item).permit(:name, :description, :price)
  end
end
