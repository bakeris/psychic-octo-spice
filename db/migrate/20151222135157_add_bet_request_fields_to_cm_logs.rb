class AddBetRequestFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :get_bet_request_body, :text
    add_column :cm_logs, :get_bet_response, :text
    add_column :cm_logs, :get_bet_id, :string
  end
end
