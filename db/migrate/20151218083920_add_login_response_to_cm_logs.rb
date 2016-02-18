class AddLoginResponseToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :login_response, :text
    add_column :cm_logs, :login_request, :text
  end
end
