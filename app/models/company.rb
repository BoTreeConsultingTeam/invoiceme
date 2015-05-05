class Company < ActiveRecord::Base
  has_many :users
  has_many :clients
  has_many :invoices, through: :clients
  validates_presence_of :name
end
