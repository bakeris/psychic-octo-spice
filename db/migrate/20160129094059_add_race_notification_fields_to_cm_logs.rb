class AddRaceNotificationFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :notify_race_connection_id, :string
    add_column :cm_logs, :notify_race_program_id, :string
    add_column :cm_logs, :notify_race_race_id, :string
    add_column :cm_logs, :notify_race_reason, :string
    add_column :cm_logs, :notify_race_request_body, :text
    add_column :cm_logs, :notify_race_response, :text
  end
end
