class InvoicesController < ApplicationController
  PATH = 'app/assets/stylesheets'
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
    @invoice.date_of_issue = Date.strptime(params[:invoice][:date_of_issue],"%m/%d/%Y")
    @invoice.paid_to_date = Date.strptime(params[:invoice][:paid_to_date],"%m/%d/%Y")
    @invoice.address = Address.new.tap do |addr|
      invoice_address = @invoice.client.address
      addr.street_1 = invoice_address.street_1
      addr.street_2 = invoice_address.street_2
      addr.city = invoice_address.city
      addr.state = invoice_address.state
      addr.pincode = invoice_address.pincode
      addr.country_code = invoice_address.country_code
    end
    if @invoice.save
      if params[:email_send] == 'true'
        pdf_render
        ClientMailer.send_email(@kit.to_pdf, @invoice, current_user).deliver
      end
      if params[:email_send] == 'true'
        @invoice.status = 'sent'
      else
        @invoice.status = 'draft'
      end
      @invoice.save
      flash[:success] = 'Invoice created successfully.'
      redirect_to invoices_path
    else
      flash[:error] = "Unable to save invoice. Reason - #{add_flash_messages(@invoice)}"
      render :new
    end
  end

  def update
    ActionController::Parameters.permit_all_parameters = true
    params1 = ActionController::Parameters.new(date_of_issue: Date.strptime(params[:invoice][:date_of_issue],"%m/%d/%Y"), paid_to_date: Date.strptime(params[:invoice][:paid_to_date], "%m/%d/%Y"))
    if @invoice.update(invoice_params)
      @invoice.update(params1)
      if @invoice.address.present?
        @invoice.address.tap do |addr|
          invoice_address = @invoice.client.address
          addr.street_1 = invoice_address.street_1
          addr.street_2 = invoice_address.street_2
          addr.city = invoice_address.city
          addr.state = invoice_address.state
          addr.pincode = invoice_address.pincode
          addr.country_code = invoice_address.country_code
        end
        if @invoice.address.save
          if @invoice.save
            if params[:email_send] == 'true'
              pdf_render
              ClientMailer.send_email(@kit.to_pdf, @invoice, current_user).deliver
            end
            if params[:email_send] == 'true'
              @invoice.status = 'sent'
            else
              @invoice.status = 'draft'
            end
            @invoice.save
            flash[:success] = 'Invoice updated successfully.'
            redirect_to invoices_path
          end
        else
          flash[:error] = "Unable to update invoice. Reason - #{add_flash_messages(@invoice)}"
          render :new
        end
      else
          @invoice.address = Address.new.tap do |addr|
            invoice_address = @invoice.client.address
            addr.street_1 = invoice_address.street_1
            addr.street_2 = invoice_address.street_2
            addr.city = invoice_address.city
            addr.state = invoice_address.state
            addr.pincode = invoice_address.pincode
            addr.country_code = invoice_address.country_code
          end
          if @invoice.save
            if params[:email_send] == 'true'
              pdf_render
              ClientMailer.send_email(@invoice.client, @kit.to_pdf, @invoice, current_user).deliver
            end
            if params[:email_send] == 'true'
              @invoice.status = 'sent'
            else
              @invoice.status = 'draft'
            end
            @invoice.save
            flash[:success] = 'Invoice updated successfully.'
            redirect_to invoices_path
          end
      end
    else
      flash[:error] = "Unable to update invoice. Reason - #{add_flash_messages(@invoice)}"
      render :new
    end
  end

  def edit
    render :new
  end

  def destroy
    if @invoice.destroy
      flash[:success] = 'Invoice deleted successfully.'
      redirect_to invoices_path
    else
      flash[:error] = "Unable to delete invoice #{@invoice.invoice_number}. Reason - #{add_flash_messages(@invoice)}"
      redirect_to invoices_path
    end
  end

  def pdf_generation
    pdf_render
    send_data @pdf, filename: "Invoice-#{@invoice.invoice_number}", type: 'application/pdf', disposition: 'attachment'
  end

  private

  def pdf_render
    html = render_to_string(action: 'show.html.haml', layout: false)
    @kit = PDFKit.new(html,
                      page_size: 'Legal',
                      footer_right: "Powered by #{current_company.name}")
    css = File.join(Rails.root,PATH,'bootstrap.min.css')
    @kit.stylesheets << css
    css1 = File.join(Rails.root,PATH,'custom.css')
    @kit.stylesheets << css1
    @pdf = @kit.to_pdf
  end

  def invoice_params
    params.require(:invoice).permit(
        :client_id, :invoice_number, :date_of_issue, :po_number, :paid_to_date, :notes, :currency_code,
        line_item_ids: [],
        line_items_attributes: [:item_id, :line_total, :price, :quantity, '_destroy', :id, :description])
  end
end