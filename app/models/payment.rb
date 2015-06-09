class Payment < ActiveRecord::Base
  belongs_to :invoice
  enum payment_method: [:check, :cash, :bank_transfer, :credit_card]
  after_save :update_status

  validates :payment_amount, presence: true
  validates :payment_method, presence: true

  def update_status
    if invoice.total_amount_payments < invoice.total_amount
      invoice.partially_paid!
    else
      invoice.paid!
    end
  end
end
