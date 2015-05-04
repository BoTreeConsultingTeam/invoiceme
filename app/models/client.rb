class Client < ActiveRecord::Base

  belongs_to :company
  
  has_one :address
  has_many :contact_details
  has_many :invoices
  
  validates_presence_of :name, :currency_code, :company_id
end
