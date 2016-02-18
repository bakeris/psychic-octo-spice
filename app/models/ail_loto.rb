class AilLoto < ActiveRecord::Base
  # Accessible fields
  attr_accessible :operation, :transaction_id, :message_id, :confirm_id, :date_time, :bet_code, :bet_modifier, :selector1, :selector2, :repeats, :special_count, :normal_count, :entries, :special_entries, :normal_entries, :response_status, :response_date_time, :response_data_name, :response_error_code, :response_error_message, :ticket_number, :ref_number, :audit_number, :bet_cost_amount, :bet_payout_amount, :response_bet_code, :response_bet_modifier, :response_selector1, :response_selector2, :response_repeats, :response_special_entries, :response_normal_entries, :refund_acknowledge, :refund_acknowledge_date_time, :cancellation_acknowledge, :cancellation_acknowledge_date_time, :placement_acknowledge, :placement_acknowledge_date_time, :remote_ip_address, :gamer_id, :paymoney_account_number, :paymoney_transaction_id, :bet_placed, :bet_placed_at, :bet_cancelled, :bet_cancelled_at, :error_description, :response_body, :user_id, :earning_paid, :earning_paid_at, :cancellation_paymoney_id, :payment_paymoney_id, :draw_id, :game_account_token, :paymoney_validation_id, :paymoney_account_token, :earning_amount, :refund_amount, :refund_paid, :refund_amount_at, :paymoney_earning_id, :paymoney_refund_id, :bet_validated, :bet_validated_at, :earning_notification_received, :earning_notification_received_at, :refund_notification_received, :refund_notification_received_at, :sms_sent, :sms_content, :message_id, :sms_status, :sms_id, :error_code, :race_id, :begin_date, :end_date, :draw_day, :draw_number, :bet_status, :basis_amount

  # Relationships
  belongs_to :user
end
