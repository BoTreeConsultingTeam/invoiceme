class AddPolymorphicAddress < ActiveRecord::Migration
  def up
    remove_column :addresses, :client_id, :integer
    change_table :addresses do |t|
      t.references :addressdetail, :polymorphic => true
    end
  end

  def down
    change_table :addresses do |t|
      t.remove_references :addressdetail, :polymorphic => true
    end
    add_column :addresses, :client_id, :integer
  end
end
