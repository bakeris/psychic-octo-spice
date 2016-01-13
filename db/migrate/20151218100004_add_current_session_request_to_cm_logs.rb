class AddCurrentSessionRequestToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :current_session_request, :text
    add_column :cm_logs, :current_session_response, :text
  end
end
