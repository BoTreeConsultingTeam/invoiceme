module PaymentsHelper

  PAYMENT_METHOD_OPTIONS = Payment.payment_methods.keys
                          .map {|payment_method| [payment_method.titleize,payment_method]}

  def date_of_payment_form(payment)
      l ( payment.date_of_payment.present? ? payment.date_of_payment : Date.today )
  end

  def payment_total_formatted(payment)
    "#{payment.invoice.currency_code.upcase} #{number_with_precision(payment.payment_amount, precision: 2)}"
  end
end
