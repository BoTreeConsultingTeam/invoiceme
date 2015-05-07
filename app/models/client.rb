class Client < ActiveRecord::Base

  belongs_to :company
  
  has_one :address
  has_many :contact_details
  has_many :invoices
 
  validates :name, presence: true
  validates :currency_code, presence: true
  validates :company_id, presence: true
end
