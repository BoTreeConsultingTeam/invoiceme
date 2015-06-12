class Address < ActiveRecord::Base
  
  belongs_to :addressdetail, polymorphic: true

  validates :street_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country_code, presence: true
  validates :pincode, presence: true
  validates :pincode, zipcode: { country_code_attribute: :country_code }

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }, params:{ "obj"=> proc {|controller, model_instance| model_instance.changes}}
end
