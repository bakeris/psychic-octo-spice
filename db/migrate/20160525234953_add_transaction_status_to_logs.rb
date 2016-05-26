class AddTransactionStatusToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :transaction_status, :string
  end
end
