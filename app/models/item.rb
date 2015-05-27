class Item < ActiveRecord::Base
  has_many :taxes
  has_many :line_items
  validates :name, presence: true
  validates :price, presence: true
  validates :price, format: { :with => /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0, only_integer: false }

end
