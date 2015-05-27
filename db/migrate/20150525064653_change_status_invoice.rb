class ChangeStatusInvoice < ActiveRecord::Migration
  def change
    remove_column :invoices, :status, :string
    add_column :invoices, :status, :integer
  end
end
