class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :client_id
      t.string :invoice_number
      t.datetime :date_of_issue
      t.string :po_number
      t.float :discount
      t.float :subtotal
      t.float :total
      t.datetime :paid_to_date
      t.float :balance
      t.string :notes
      t.text :terms
      t.integer :payment_days

      t.timestamps null: false
    end
  end
end
