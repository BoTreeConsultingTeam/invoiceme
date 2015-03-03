class CreateContactDetails < ActiveRecord::Migration
  def change
    create_table :contact_details do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :mobile
      t.integer :client_id
      t.timestamps null: false
    end
  end
end
