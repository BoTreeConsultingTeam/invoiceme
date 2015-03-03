class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :country_id
      t.string :street_1
      t.string :street_2
      t.string :city
      t.string :state
      t.integer :pincode
      t.integer :client_id
      t.timestamps null: false
    end
  end
end
