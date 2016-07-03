class AddGetResultNotificationFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :get_results_request_body, :text
    add_column :cm_logs, :get_results_request_response, :text
    add_column :cm_logs, :get_results_code, :string
  end
end
