class RemoveAdminId < ActiveRecord::Migration
  def change
    remove_column :users, :admin_id, :integer
  end
end
