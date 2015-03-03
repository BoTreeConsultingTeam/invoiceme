class Client < ActiveRecord::Base

  attr_accessible :currency, :notes

  belongs_to :currency
  belongs_to :company
  
  has_one :address
  has_many :contact_details
  has_many :invoices
  
end
