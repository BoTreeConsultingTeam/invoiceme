class Company < ActiveRecord::Base

  has_one :address, as: :addressdetail
  has_many :users
  has_many :clients
  has_many :invoices, through: :clients

  delegate :street_1, :street_2, :city, :state, :pincode, :country_code, to: :address, prefix: true
  
  accepts_nested_attributes_for :address, :allow_destroy => true
  
  validates_presence_of :name
  
end
