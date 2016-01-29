class AddNotificationFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :notify_session_request_body, :text
    add_column :cm_logs, :notify_session_request_result, :text
  end
end
