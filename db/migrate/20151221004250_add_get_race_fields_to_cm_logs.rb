class AddGetRaceFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :get_race_request_body, :text
    add_column :cm_logs, :get_race_code, :string
    add_column :cm_logs, :get_race_response, :text
  end
end
