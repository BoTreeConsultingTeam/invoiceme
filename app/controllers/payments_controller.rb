class PaymentsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :find_invoice

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
    @payment.date_of_payment = format_date_locale(params[:payment][:date_of_payment])
    if @payment.save
      begin
        ClientMailer.send_email_payment(@invoice, current_user).deliver if params[:email].present?
        flash[:success] = 'Payment saved successfully.'
        redirect_to invoice_payments_path
      rescue
        flash[:error] = "Problem while sending email."
        render :action => 'new'
      end
    else
      flash[:error] = "Problem while saving payment details. #{@payment.errors.full_messages.join(',')}"
      render :action => 'new'
    end
  end

  def find_invoice
    @invoice = Invoice.find(params[:invoice_id])
  end

  def update
    params_date_of_payment = ActionController::Parameters.new(date_of_payment: format_date_locale(params[:payment][:date_of_payment])).permit(:date_of_payment)
    if @payment.update(payment_params)
      @payment.update(params_date_of_payment)
      flash[:success] = 'Payment updated successfully.'
      redirect_to invoice_payments_path(@invoice)
    else
      flash[:error] = "Problem while updating payment details. #{@payment.errors.full_messages.join(',')}"
      render :action => 'edit'
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:invoice_id, :payment_amount, :payment_method, :date_of_payment, :notes)
  end
end
