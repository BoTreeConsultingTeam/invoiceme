class InvoicesController < ApplicationController
  STYLE_SHEETS_ASSET_PATH = 'app/assets/stylesheets'
  BOOTSTRAP_MIN_CSS = File.join(Rails.root, STYLE_SHEETS_ASSET_PATH, 'bootstrap.min.css')
  CUSTOM_CSS = File.join(Rails.root,STYLE_SHEETS_ASSET_PATH, 'custom.css')
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :replace_date_params, only: [ :create, :update ]
  before_action :is_client_exists?, only: [ :index, :new, :edit ]

  def index
    @invoices = current_company.invoices
  end

  def new
    @invoice = Invoice.new
    @invoice.line_items << LineItem.new
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.address = copy_address!(Address.new)
    if @invoice.save
      if params[:email_send] == 'true'
        send_invoice_to_client
        @invoice.sent!
      end
      flash[:success] = 'Invoice created successfully.'
      redirect_to invoices_path
    else
      flash[:error] = "Unable to save invoice. Reason - #{add_flash_messages(@invoice)}"
      render :new
    end
  end

  def update
    if @invoice.update(invoice_params)
      if @invoice.address.present?
        copy_address!(@invoice.address)
        if @invoice.address.save
          if @invoice.save
            if params[:email_send] == 'true'
              send_invoice_to_client
              @invoice.sent!
            end
            flash[:success] = 'Invoice updated successfully.'
            redirect_to invoices_path
          end
        else
          flash[:error] = "Unable to update invoice. Reason - #{add_flash_messages(@invoice)}"
          render :new
        end
      else
        @invoice.address = copy_address!(Address.new)
        if @invoice.save
          if params[:email_send] == 'true'
            send_invoice_to_client
            @invoice.sent!
          end
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

  def copy_address!(address)
    address.tap do |addr|
      invoice_address = @invoice.client.address
      addr.street_1 = invoice_address.street_1
      addr.street_2 = invoice_address.street_2
      addr.city = invoice_address.city
      addr.state = invoice_address.state
      addr.pincode = invoice_address.pincode
      addr.country_code = invoice_address.country_code
    end
  end

  def send_invoice_to_client
    pdf_render
    ClientMailer.send_email(@kit.to_pdf, @invoice, current_user).deliver
  end

  def pdf_render
    html = render_to_string(action: 'show.html.haml', layout: false)
    @kit = PDFKit.new(html,
                      page_size: 'Legal',
                      footer_right: "#{current_company.name}")
    @kit.stylesheets << BOOTSTRAP_MIN_CSS
    @kit.stylesheets << CUSTOM_CSS
    @pdf = @kit.to_pdf
  end

  def replace_date_params
    params[:invoice][:date_of_issue] = format_date_locale(params[:invoice][:date_of_issue])
    params[:invoice][:paid_to_date] = format_date_locale(params[:invoice][:paid_to_date])
  end

  def invoice_params
    params.require(:invoice).permit(
        :client_id, :invoice_number, :date_of_issue, :po_number, :paid_to_date, :notes, :currency_code,
        line_item_ids: [],
        line_items_attributes: [:item_id, :line_total, :price, :quantity, '_destroy', :id, :description])
  end

  def is_client_exists?
    flash[:error] = t('clients.messages.create_client_for_invoice')
    redirect_to clients_path unless Client.exists?
  end
end