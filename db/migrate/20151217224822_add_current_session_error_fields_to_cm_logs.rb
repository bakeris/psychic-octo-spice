class AddCurrentSessionErrorFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :current_session_error_code, :string
    add_column :cm_logs, :current_session_error_description, :text
  end
end
