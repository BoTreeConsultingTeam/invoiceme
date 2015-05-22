class Payment < ActiveRecord::Base
  belongs_to :invoice
  enum payment_method: ["check", "cash", "bank transfer", "credit card"]

  def date_of_payment=(val)
    write_attribute(:date_of_payment, parse_date(val)) if val.present?
  end

  def parse_date(date_value, format = "%m/%d/%Y")
    Date.strptime(date_value, format) if date_value.present?
  end
end
