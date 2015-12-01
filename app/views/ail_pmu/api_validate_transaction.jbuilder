if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.bet do
    json.ticket_number @bet.ticket_number rescue nil
    json.ref_number @bet.ref_number rescue nil
    json.audit_number @bet.audit_number rescue nil
    json.bet_payout_amount @bet.bet_payout_amount rescue nil
  end
end
