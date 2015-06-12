class ContactDetail < ActiveRecord::Base
  belongs_to :client

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
  validates :mobile, presence: true

  validates :email, format: { with: Devise.email_regexp, message: "doesn't look like an email address" }
  validates :phone, format: { with: /\d[0-9]/, message: "Only positive number without spaces are allowed" }
  validates :mobile, format: { with: /\d[0-9]/, message: "Only positive number without spaces are allowed" }

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }, params:{ "obj"=> proc {|controller, model_instance| model_instance.changes}}

end
