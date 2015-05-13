class ItemsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :clear_error, only: :index

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def edit
    render :new
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
      flash[:error] = "Unable to update the item because: #{@item.errors.full_messages.join(',')}"
    end
    render :create
  end

  def destroy
    if @item.destroy
      flash[:success] = "Item deleted successfully"
    else
      flash[:error] = "Unable to delete the item because: #{@item.errors.full_messages.join(',')}"
    end
    redirect_to items_path
  end

  def clear_error
    if flash[:error].present?
      flash.clear
    end
  end

  protected

  def item_params
    params.require(:item).permit(:name, :description, :price)
  end
end
