class InvNoInteger < ActiveRecord::Migration
  def change
    remove_column :invoices, :invoice_number, :string
    add_column :invoices, :invoice_number, :integer
  end
end
