class Cm < ActiveRecord::Base

  # Relationship
  has_many :cm_wagers

  # Accessible fields
  attr_accessible :connection_id, :program_id, :race_id, :sale_client_id, :punter_id, :amount, :scratched_list, :serial_number, :bet_placed_at, :placement_request, :placement_response, :game_account_token, :paymoney_account_number, :paymoney_account_token, :p_payment_transaction_id, :p_payment_request, :p_payment_response, :payment_error_code, :payment_error_description, :cancel_request, :cancel_response, :cancelled, :cancelled_at, :p_cancellation_id, :suid, :win_amount, :win_reason, :win_bet_ids, :win_checksum, :win_request, :win_response, :p_validation_request, :p_validation_response, :p_validation_id, :p_validated, :p_validated_at, :pay_earning_request, :pay_earning_response, :p_earning_id, :pay_refund_request, :pay_refund_response, :p_refund_id, :remote_ip, :transaction_id, :bet_identifier, :begin_date, :end_date, :bet_status, :sms_sent, :sms_content, :sms_status, :sms_id

end
