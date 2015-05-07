class Client < ActiveRecord::Base

  belongs_to :company
  delegate :street_1, :street_2, :city, :state, :pincode, :country_code, to: :address, prefix: true
  has_one :address
  has_many :contact_details
  has_many :invoices
 
  accepts_nested_attributes_for :address, :allow_destroy => true

  validates :name, presence: true
  validates :currency_code, presence: true
  validates :company_id, presence: true
end
