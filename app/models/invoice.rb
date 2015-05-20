class Invoice < ActiveRecord::Base
  has_many :line_items
  belongs_to :client
  has_one :address, as: :addressdetail
  accepts_nested_attributes_for :line_items, allow_destroy: true
  acts_as_sequenced column: :invoice_number, start_at: 1000

  def self.find_next_available_number_for(default=1000)
    (self.maximum(:invoice_number) || default).succ
  end

  def date_of_issue=(val)
    write_attribute(:date_of_issue, parse_date(val)) if val.present?
  end

  def paid_to_date=(val)
    write_attribute(:paid_to_date, parse_date(val)) if val.present?
  end

  def parse_date(date_value, format = "%m/%d/%Y")
    Date.strptime(date_value, format) if date_value.present?
  end

  def total_amount
    total = line_items.inject(0.0) do |total,line_item|
      total + line_item.line_total.to_f
    end
    total
  end
end
