class AddLoginErrorFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :login_error_code, :string
    add_column :cm_logs, :login_error_description, :text
  end
end
