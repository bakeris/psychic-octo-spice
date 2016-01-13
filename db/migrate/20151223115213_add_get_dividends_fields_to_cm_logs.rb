class AddGetDividendsFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :get_dividends_request_body, :text
    add_column :cm_logs, :get_dividends_response, :text
    add_column :cm_logs, :get_dividends_code, :string
  end
end
