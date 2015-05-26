class Invoice < ActiveRecord::Base
  has_many :line_items
  has_many :payments
  belongs_to :client
  has_one :address, as: :addressdetail, dependent: :destroy
  accepts_nested_attributes_for :line_items, allow_destroy: true
  acts_as_sequenced column: :invoice_number, start_at: 1000
  enum status: ['draft', 'sent', 'partially paid', 'paid']

  def self.find_next_available_number_for(default=1000)
    (self.maximum(:invoice_number) || default).succ
  end

  def total_amount
    total = line_items.inject(0.0) do |total,line_item|
      total + line_item.line_total.to_f
    end
    total
  end

  def total_amount_payments
    total = payments.inject(0.0) do |total,payment|
      total + payment.payment_amount.to_f
    end
    total
  end
end
