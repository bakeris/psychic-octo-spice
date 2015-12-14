class Eppl < ActiveRecord::Base
  # Accessible fields
  attr_accessible :transaction_id, :paymoney_account, :transaction_amount, :bet_placed, :bet_placed_at, :earning_paid, :earning_paid_at, :paymoney_transaction_id, :error_code, :error_description, :response_body, :remote_ip, :paymoney_account_token, :earning_transaction_id, :user_id, :gamer_id, :bet_placed, :bet_placed_at, :bet_cancelled, :bet_cancelled_at, :cancellation_paymoney_id, :payment_paymoney_id, :game_account_token, :bet_validated, :bet_validated_at, :paymoney_validation_id

  # Relationships
  belongs_to :user
end
