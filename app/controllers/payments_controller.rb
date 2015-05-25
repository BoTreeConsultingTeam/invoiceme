class PaymentsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @payments = current_company.payments
  end

  def new
    @payment = Payment.new
    find_invoice(params[:id])
  end

  def edit
    find_invoice(@payment.invoice_id)
    params[:id] = @payment.invoice_id
  end

  def create
    @payment = Payment.new(payment_params)
    find_invoice(params[:id])
    if @payment.save
      if @payment.invoice.total_amount_payments < @payment.invoice.total_amount
        @payment.invoice.status = Invoice.statuses["partially paid"]
      else
        @payment.invoice.status = Invoice.statuses["paid"]
      end
      @payment.invoice.save
      if(params[:email].present?)
        ClientMailer.send_email_payment(@payment.invoice.client, @payment.invoice, current_user).deliver
      end
      flash[:success] = 'Payment saved successfully.'
      redirect_to payments_path
    else
      flash[:error] = "Problem while saving payment details. #{@payment.errors.full_messages.join(',')}"
      render :action => 'new'
    end
  end

  def find_invoice(id)
    @payment.invoice = Invoice.find(id)
  end

  def update
    if @payment.update(payment_params)
      if @payment.invoice.total_amount_payments < @payment.invoice.total_amount
        @payment.invoice.status = Invoice.statuses["partially paid"]
      else
        @payment.invoice.status = Invoice.statuses["paid"]
      end
      @payment.invoice.save
      flash[:success] = 'Payment saved successfully.'
      redirect_to payments_path
    else
      flash[:error] = "Problem while saving payment details. #{@payment.errors.full_messages.join(',')}"
      render :action => 'edit'
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:invoice_id, :payment_amount, :payment_method, :date_of_payment, :notes)
  end
end
