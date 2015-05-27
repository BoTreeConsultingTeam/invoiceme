class AddCurrencyCodeInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :currency_code, :string
  end
end
