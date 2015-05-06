class ChangeCurrencyToCode < ActiveRecord::Migration
  def change
  	remove_column :clients, :currency_id
  	add_column :clients, :currency_code, :string
  end
end
