class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :invoice_id
      t.float :payment_amount
      t.integer :payment_method
      t.date :date_of_payment
      t.text :notes
      t.timestamps null: false
    end
  end
end
