class QueryBet < ActiveRecord::Base
  # Relationships
  belongs_to :user

  # Set accessible fields
  attr_accessible :user_id, :confirm_id, :op_code, :bet_code, :bet_modifier, :selector1, :selector2, :repeats, :special_count, :normal_count, :entries, :status, :response_message_id, :response_user_id, :response_datetime, :audit_number, :bet_cost_amount, :response_bet_code, :response_bet_modifier, :response_selector1, :response_selector2, :response_repeats, :response_special_count, :response_normal_count, :response_entries, :error_code, :error_message

end
