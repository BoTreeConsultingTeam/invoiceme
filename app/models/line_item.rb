class LineItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :invoice
  validates :item_id, presence: true
  #has_many :line_item_taxes
  belongs_to :tax_1, :class_name => "Tax", :foreign_key => "tax1"
  belongs_to :tax_2, :class_name => "Tax", :foreign_key => "tax2"
  #accepts_nested_attributes_for :line_item_taxes, allow_destroy: true
end
