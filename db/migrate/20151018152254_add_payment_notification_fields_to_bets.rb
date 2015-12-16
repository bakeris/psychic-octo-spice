class AddPaymentNotificationFieldsToBets < ActiveRecord::Migration
  def change
    add_column :bets, :pn_ticket_status, :string
    add_column :bets, :pn_amount_win, :string
    add_column :bets, :pn_timestamp, :string
    add_column :bets, :pn_transaction_id, :string
    add_column :bets, :pn_event_ticket_status, :string
    add_column :bets, :pn_type_result, :string
    add_column :bets, :pn_winning_value, :string
    add_column :bets, :pn_winning_position, :string
  end
end
