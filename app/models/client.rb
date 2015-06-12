class Client < ActiveRecord::Base

  belongs_to :company
  has_one :address, as: :addressdetail
  has_many :contact_details
  has_many :invoices

  delegate :street_1, :street_2, :city, :state, :pincode, :country_code, to: :address, prefix: true
 
  accepts_nested_attributes_for :address, allow_destroy: true
  accepts_nested_attributes_for :contact_details, allow_destroy: true

  validates :name, presence: true
  validates :currency_code, presence: true
  validates :company_id, presence: true

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }, params:{ "obj"=> proc {|controller, model_instance| model_instance.changes}}

end
