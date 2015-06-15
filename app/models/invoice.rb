class Invoice < ActiveRecord::Base
  has_many :line_items
  has_many :payments
  belongs_to :client
  has_one :address, as: :addressdetail, dependent: :destroy
  accepts_nested_attributes_for :line_items, allow_destroy: true
  acts_as_sequenced column: :invoice_number, start_at: 1000

  enum status: [:draft, :sent, :partially_paid, :paid]

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }, params:{ "obj"=> proc {|controller, model_instance| model_instance.changes}}

  def self.find_next_available_number_for(default=1000)
    (self.maximum(:invoice_number) || default).succ
  end

  def sub_total
    total = line_items.inject(0.0) do |total,line_item|
      total + line_item.line_total.to_f
    end
  end

  def total_amount
    total = line_items.inject(0.0) do |total,line_item|
      total + line_item.line_total.to_f
    end
    total.to_f - (total.to_f*discount.to_f)/100.00

  end

  def total_amount_payments
    total = payments.inject(0.0) do |total,payment|
      total + payment.payment_amount.to_f
    end
    total
  end

end
