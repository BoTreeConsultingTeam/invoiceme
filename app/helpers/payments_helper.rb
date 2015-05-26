module PaymentsHelper

  PAYMENT_METHOD_OPTIONS = Payment.payment_methods.keys.map {|payment_method| [payment_method.titleize,payment_method]}

end
