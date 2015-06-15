class Tax < ActiveRecord::Base
  belongs_to :parent, class_name: "Tax", :foreign_key => :parent_id
  has_many :line_items

  validates :rate, presence: true
  validates :name, presence: true
  validates :rate, format: { :with => /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0, only_integer: false }, allow_blank: true
end
