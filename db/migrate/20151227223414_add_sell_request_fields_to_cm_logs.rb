class AddSellRequestFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :sell_ticket_request, :text
    add_column :cm_logs, :sell_ticket_response, :text
    add_column :cm_logs, :sell_ticket_code, :string
  end
end
