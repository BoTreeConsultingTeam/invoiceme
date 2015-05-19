class InvoicesController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @invoices = Invoice.all
  end

  def new
    @invoice = Invoice.new
    @invoice.line_items << LineItem.new
  end

  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save
      flash[:success] = "Invoice created successfully."
      redirect_to invoices_path
    else
      flash[:error] = "Invoice not saved because: #{@invoice.errors.full_messages.join(',')}"
      render :new
    end
  end

  def update
    if @invoice.update(invoice_params)
      flash[:success] = "Invoice updated successfully."
      redirect_to invoices_path
    else
      flash[:error] = "Invoice not updated because: #{@invoice.errors.full_messages.join(',')}"
      render :new
    end
  end

  def edit
    render :new
  end

  private

  def invoice_params
    params.require(:invoice).permit(
        :client_id, :invoice_number, :date_of_issue, :po_number, :paid_to_date, :notes,
        line_item_ids: [],
        line_items_attributes: [:item_id, :line_total, :price, :quantity, "_destroy", :id])
  end
end