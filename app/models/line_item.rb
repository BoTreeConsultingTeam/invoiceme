class LineItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :invoice
  validates :item_id, presence: true
end
