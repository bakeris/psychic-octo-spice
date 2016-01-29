class AddDetailedNotificationFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :session_notification_connection_id, :string
    add_column :cm_logs, :session_notification_session_id, :string
    add_column :cm_logs, :session_notification_reason, :string
  end
end
