if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.game "PMU PLR"
  json.bets @bets do |bet|
    json.ticket_number bet.ticket_number rescue nil
    json.ref_number bet.ref_number rescue nil
    json.transaction_id bet.transaction_id rescue nil
    json.audit_number bet.audit_number rescue nil
    json.bet_cost_amount bet.bet_cost_amount rescue nil
    json.bet_payout_amount bet.bet_payout_amount rescue nil
    json.bet_code bet.bet_code rescue nil
    json.bet_modifier bet.bet_modifier rescue nil
    json.selector1 bet.selector1 rescue nil
    json.selector2 bet.selector2 rescue nil
    json.repeats bet.repeats rescue nil
    json.special_entries "[#{bet.special_entries}]" rescue nil
    json.normal_entries "[#{bet.normal_entries}]" rescue nil
    json.bet_placed bet.placement_acknowledge rescue nil
    json.bet_placed_at bet.placement_acknowledge_date_time rescue nil
    json.bet_cancelled bet.cancellation_acknowledge rescue nil
    json.bet_cancelled_at bet.cancellation_acknowledge_date_time rescue nil
    json.bet_refunded bet.refund_acknowledge rescue nil
    json.bet_refunded_at bet.refund_acknowledge_date_time rescue nil
    json.earning_paid bet.earning_paid ? "true" : "false"
    json.earning_paid_at bet.earning_paid_at.to_s
    json.paymoney_earning_id bet.paymoney_earning_id
    json.refund_paid bet.refund_paid ? "true" : "false"
    json.refund_paid_at bet.refund_paid_at.to_s
    json.paymoney_refund_id bet.paymoney_refund_id
    json.begin_date bet.begin_date recue nil
    json.end_date bet.end_date recue nil
  end
end
