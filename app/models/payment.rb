class Payment < ActiveRecord::Base
  belongs_to :invoice
  enum payment_method: ['check', 'cash', 'bank transfer', 'credit card']
  after_save :update_status

  def update_status
    if invoice.total_amount_payments < invoice.total_amount
      invoice.status = Invoice.statuses['partially paid']
    else
      invoice.status = Invoice.statuses['paid']
    end
    invoice.save
  end
end
