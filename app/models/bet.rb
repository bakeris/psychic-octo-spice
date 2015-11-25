class Bet < ActiveRecord::Base
  # Accessible fields
  attr_accessible :license_code, :pos_code, :terminal_id, :account_id, :account_type, :transaction_id, :amount, :win_amount, :validated, :validated_at, :ticket_id, :ticket_timestamp, :transaction_id, :cancelled, :cancelled_at, :cancellation_timestamp, :remote_ip_address, :pn_ticket_status, :pn_amount_win, :pn_timestamp, :pn_transaction_id, :pn_event_ticket_status, :pn_type_result, :pn_winning_value, :pn_winning_position, :pr_transaction_id, :pr_status, :payment_status_datetime, :user_id

  # Relationships
  has_many :bet_coupons
  belongs_to :user
end
