class ChangeLineItemTax < ActiveRecord::Migration
  def change
    add_column :line_items, :tax1, :integer
    add_column :line_items, :tax2, :integer
  end
end
