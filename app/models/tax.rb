class Tax < ActiveRecord::Base
  belongs_to :parent, class_name: "Tax", :foreign_key => :parent_id
  has_many :line_items

  validates :rate, presence: true
  validates :name, presence: true
end
