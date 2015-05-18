class InvoicesController < ApplicationController

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
      redirect_to invoices_path
    else
      render :new
    end
  end

  def update
    @invoice = Invoice.find(params[:id])
    if @invoice.update(invoice_params)
      redirect_to invoices_path
    else
      render :new
    end
  end

  def edit
    @invoice = Invoice.find(params[:id])
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