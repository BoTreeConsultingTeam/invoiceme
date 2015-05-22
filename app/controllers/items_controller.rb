class ItemsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  before_filter :check_authorized_access, except: [:index, :new, :create]

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
      flash[:error] = "Item not saved because: #{add_flash_messages(@item)}"
    end
  end

  def update
    if @item.update(item_params)
      flash.clear
      flash[:success] = "Item updated successfully"
    else
      flash.clear
      flash[:error] = "Unable to update the item because: #{add_flash_messages(@item)}"
    end
    render :create
  end

  def destroy
    if @item.destroy
      flash[:success] = "Item deleted successfully"
    else
      flash[:error] = "Unable to delete the item because: #{add_flash_messages(@item)}"
    end
    redirect_to items_path
  end

  def populate_values_of_item
    @item = Item.find(params[:item_id])
    render :json => {:data => {:item => @item, :form_id => params[:form_id]}}
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price)
  end

  def check_authorized_access
    raise CanCan::AccessDenied.new("Unauthorized access!", :read, Item) unless current_user.admin?
  end
end
