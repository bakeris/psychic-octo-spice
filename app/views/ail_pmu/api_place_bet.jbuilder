if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.bet @bet do |bet|
    json.ticket_number draw.at('ticketNumber').content
    json.ref_number draw.at('refNumber').content
    json.audit_number draw.at('auditNumber').content
    json.bet_cost_amount draw.at('betCostAmount').content
    json.bet_payout_amount draw.at('betPayoutAmount').content
    json.bet_code draw.at('betCode').content
    json.bet_modifier draw.at('betModifier').content
    json.selector1 draw.at('selector1').content
    json.selector2 draw.at('selector2').content
    json.repeats draw.at('repeats').content
    json.special_entries draw.at('specialEntries').content
    json.normal_entries draw.at('special_entries').content
  end
end
