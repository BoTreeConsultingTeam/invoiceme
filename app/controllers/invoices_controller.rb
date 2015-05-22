class InvoicesController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @invoices = current_company.invoices
  end

  def new
    @invoice = Invoice.new
    @invoice.line_items << LineItem.new
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.address = Address.new()
    @invoice.address.street_1 = @invoice.client.address.street_1
    @invoice.address.street_2 = @invoice.client.address.street_2
    @invoice.address.city = @invoice.client.address.city
    @invoice.address.state = @invoice.client.address.state
    @invoice.address.pincode = @invoice.client.address.pincode
    @invoice.address.country_code = @invoice.client.address.country_code
    if params[:email_send] == "true"
      @invoice.status = 'sent'
    else
      @invoice.status = 'draft'
    end
    if @invoice.save
      if params[:email_send] == "true"
        pdf_render
        ClientMailer.send_email(@invoice.client,@kit.to_pdf, @invoice, current_user).deliver
      end
      flash[:success] = "Invoice created successfully."
      redirect_to invoices_path
    else
      flash[:error] = "Invoice not saved because: #{@invoice.errors.full_messages.join(',')}"
      render :new
    end
  end

  def update
    if @invoice.update(invoice_params)
      if @invoice.address.present?
        @invoice.address.street_1 = @invoice.client.address.street_1
        @invoice.address.street_2 = @invoice.client.address.street_2
        @invoice.address.city = @invoice.client.address.city
        @invoice.address.state = @invoice.client.address.state
        @invoice.address.pincode = @invoice.client.address.pincode
        @invoice.address.country_code = @invoice.client.address.country_code
        if @invoice.address.save
          if params[:email_send] == "true"
            @invoice.status = 'sent'
          else
            @invoice.status = 'draft'
          end
          if @invoice.save
            if params[:email_send] == "true"
              pdf_render
              ClientMailer.send_email(@invoice.client, @kit.to_pdf, @invoice, current_user).deliver
            end
          flash[:success] = "Invoice updated successfully."
          redirect_to invoices_path
          end
        else
          flash[:error] = "Invoice not updated because: #{@invoice.address.errors.full_messages.join(',')}"
          render :new
        end
      else
          if params[:email_send] == "true"
            @invoice.status = 'sent'
          else
            @invoice.status = 'draft'
          end
          if @invoice.save
            if params[:email_send] == "true"
              pdf_render
              ClientMailer.send_email(@invoice.client, @kit.to_pdf, @invoice, current_user).deliver
            end
            flash[:success] = "Invoice updated successfully."
            redirect_to invoices_path
          end
      end
    else
      flash[:error] = "Invoice not updated because: #{@invoice.errors.full_messages.join(',')}"
      render :new
    end
  end

  def edit
    render :new
  end

  def destroy
    if @invoice.destroy
      @invoice.address.destroy if @invoice.address.present?
      flash[:success] = "Invoice deleted successfully."
      redirect_to invoices_path
    else
      flash[:error] = "Invoice not deleted because: #{@invoice.errors.full_messages.join(',')}"
      redirect_to invoices_path
    end
  end

  def pdf_render
    html = render_to_string(action: "show.html.haml", layout: false)
    @kit = PDFKit.new(html,
                     page_size: 'Legal',
                     footer_right: "Powered by Botree Consulting")
    css = File.join(Rails.root,'app/assets/stylesheets','bootstrap.min.css')
    @kit.stylesheets << css
    css1 = File.join(Rails.root,'app/assets/stylesheets','custom.css')
    @kit.stylesheets << css1
    @pdf = @kit.to_pdf
  end

  def pdf_generation
    pdf_render
    send_data @pdf, filename: "Invoice", type: "application/pdf", disposition: "attachment"
  end

  private

  def invoice_params
    params.require(:invoice).permit(
        :client_id, :invoice_number, :date_of_issue, :po_number, :paid_to_date, :notes, :currency_code,
        line_item_ids: [],
        line_items_attributes: [:item_id, :line_total, :price, :quantity, "_destroy", :id, :description])
  end
end