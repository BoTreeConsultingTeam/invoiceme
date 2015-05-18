class Invoice < ActiveRecord::Base
  has_many :line_items
  belongs_to :client

  accepts_nested_attributes_for :line_items, :allow_destroy => true

  validates :item_id, presence: true
end
