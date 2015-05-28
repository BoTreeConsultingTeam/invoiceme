class ChangeStatusDefault < ActiveRecord::Migration
  def change
    remove_column :invoices, :status, :integer
    add_column :invoices, :status, :integer, default: 0, null: false
  end
end
