class AddSessionIdToDepositLogs < ActiveRecord::Migration
  def change
    add_column :deposit_logs, :session_id, :string
  end
end
