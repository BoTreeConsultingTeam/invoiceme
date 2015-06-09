class AddParentTax < ActiveRecord::Migration
  def change
    add_column :taxes, :parent_id, :integer
  end
end
