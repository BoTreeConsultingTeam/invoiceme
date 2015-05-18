class Invoice < ActiveRecord::Base
  has_many :line_items
  belongs_to :client

  accepts_nested_attributes_for :line_items, :allow_destroy => true
  acts_as_sequenced column: :invoice_number, start_at: 1000

  def self.find_next_available_number_for(default=1000)
    (self.maximum(:invoice_number) || default).succ
  end

  def date_of_issue=(val)
    date = Date.strptime(val, "%m/%d/%Y") if val.present?
    write_attribute(:date_of_issue, date)
  end

  def paid_to_date=(val)
    date = Date.strptime(val, "%m/%d/%Y") if val.present?
    write_attribute(:paid_to_date, date)
  end
end
