class ChangeCountryToCode < ActiveRecord::Migration
  def change
  	remove_column :addresses, :country_id, :integer
  	add_column :addresses, :country_code, :string
  end
end
