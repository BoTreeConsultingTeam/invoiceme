class PaymentsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    find_invoice(params[:invoice_id])
    @payments = @invoice.payments
  end

  def new
    @payment = Payment.new
    find_invoice(params[:invoice_id])
  end

  def edit
    find_invoice(params[:invoice_id])
    @payment = Payment.find(params[:id])
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.date_of_payment = format_date_locale(params[:payment][:date_of_payment])
    find_invoice(params[:invoice_id])
    if @payment.save
      ClientMailer.send_email_payment(@invoice, current_user).deliver if params[:email].present?
      flash[:success] = 'Payment saved successfully.'
      redirect_to invoice_payments_path
    else
      flash[:error] = "Problem while saving payment details. #{@payment.errors.full_messages.join(',')}"
      render :action => 'new'
    end
  end

  def find_invoice(id)
    @invoice = Invoice.find(id)
  end

  def update
    find_invoice(params[:invoice_id])
    ActionController::Parameters.permit_all_parameters = true
    params1 = ActionController::Parameters.new(date_of_payment: format_date_locale(params[:payment][:date_of_payment]))
    if @payment.update(payment_params)
      @payment.update(params1)
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
