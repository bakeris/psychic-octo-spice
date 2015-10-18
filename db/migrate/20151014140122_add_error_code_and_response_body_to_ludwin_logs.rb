class AddErrorCodeAndResponseBodyToLudwinLogs < ActiveRecord::Migration
  def change
    add_column :ludwin_logs, :error_code, :string
    add_column :ludwin_logs, :response_body, :text
  end
end
