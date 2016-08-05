class DelayedPayment < ActiveRecord::Base
  # Accessible fields
  attr_accessible :game, :type, :payment_type, :transaction_id, :ticket_id, :cheque_id, :firstname, :lastname, :identity_number, :cheque_amount, :paymoney_account_number, :paymoney_amount, :winner_paymoney_account_request, :winner_paymoney_account_response, :paymoney_credit_request, :paymoney_credit_response, :paymoney_credit_status, :cheque_credit_request, :cheque_credit_response, :cheque_credit_status, :payback_request, :payback_response, :payback_status, :transaction_type, :bet_amount, :bet_placed_at
end
