class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.float :deduction
      t.string :description

      t.timestamps null: false
    end
  end
end
