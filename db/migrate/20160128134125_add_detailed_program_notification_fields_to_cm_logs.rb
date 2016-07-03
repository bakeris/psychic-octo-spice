class AddDetailedProgramNotificationFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :program_notification_connection_id, :string
    add_column :cm_logs, :program_notification_program_id, :string
    add_column :cm_logs, :program_notification_reason, :string
  end
end
