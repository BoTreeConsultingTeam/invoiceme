class InvoicesController < ApplicationController

  def new
    @invoice = Invoice.new
    @invoice.line_items << LineItem.new
  end

end
