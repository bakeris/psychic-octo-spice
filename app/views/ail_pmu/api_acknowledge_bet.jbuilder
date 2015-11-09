if @error_code != 0
  json.error code: @error_code, description: @error_description
else
  json.bet do
    json.ticket_number @bet.ticket_number
    json.ref_number @bet.ref_number
    json.audit_number @bet.audit_number
    json.bet_cost_amount @bet.bet_cost_amount
    json.bet_payout_amount @bet.bet_payout_amount
    json.bet_code @bet.bet_code
    json.bet_modifier @bet.bet_modifier
    json.selector1 @bet.selector1
    json.selector2 @bet.selector2
    json.repeats @bet.repeats
    json.special_entries @bet.special_entries
    json.normal_entries @bet.normal_entries
  end
end
