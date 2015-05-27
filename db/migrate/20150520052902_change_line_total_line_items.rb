class ChangeLineTotalLineItems < ActiveRecord::Migration
  def change
    remove_column :line_items, :line_total, :integer
    add_column :line_items, :line_total, :float
  end
end
