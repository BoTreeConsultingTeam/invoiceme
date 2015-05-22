module PaymentsHelper

  PAYMENT_METHODS = Payment.payment_methods

  def get_payment_methods
    PAYMENT_METHODS.keys.map {|payment_method| [payment_method.titleize,payment_method]}
  end

end
