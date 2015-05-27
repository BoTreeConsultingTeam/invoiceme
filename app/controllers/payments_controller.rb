class PaymentsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :find_invoice
  before_action :replace_date_params , only: [:create,:update]

  def index
    @payments = @invoice.payments
  end

  def new
    @payment = Payment.new
  end

  def edit
    @payment = Payment.find(params[:id])
  end

  def create
    @payment = @invoice.payments.build(payment_params)
    if @payment.save
      begin
        ClientMailer.send_email_payment(@invoice, current_user).deliver if params[:email].present?
        flash[:success] = 'Payment saved successfully.'
        redirect_to invoice_payments_path
      rescue
        flash[:error] = "Problem while sending email."
        render action: 'new'
      end
    else
      flash[:error] = "Problem while saving payment details. #{add_flash_messages(@payment)}"
      render action: 'new'
    end
  end


  def update
    if @payment.update(payment_params)
      flash[:success] = 'Payment updated successfully.'
      redirect_to invoice_payments_path(@invoice)
    else
      flash[:error] = "Problem while updating payment details. #{add_flash_messages(@payment)}"
      render action: 'edit'
    end
  end

  private

  def replace_date_params
    params[:payment][:date_of_payment] = format_date_locale(params[:payment][:date_of_payment])
  end

  def find_invoice
    @invoice = Invoice.find(params[:invoice_id])
  end

  def payment_params
    params.require(:payment).permit(:invoice_id, :payment_amount, :payment_method, :date_of_payment, :notes)
  end
end
