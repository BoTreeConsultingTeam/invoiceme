class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :company_id
      t.integer :currency_id
      t.string :name

      t.timestamps null: false
    end
  end
end
