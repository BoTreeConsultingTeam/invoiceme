class AddDiscountLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :discount, :float
  end
end
