class ChangeInvoiceDates < ActiveRecord::Migration
  def change
    remove_column :invoices, :date_of_issue, :datetime
    add_column :invoices, :date_of_issue, :date
    remove_column :invoices, :paid_to_date, :datetime
    add_column :invoices, :paid_to_date, :date
  end
end
