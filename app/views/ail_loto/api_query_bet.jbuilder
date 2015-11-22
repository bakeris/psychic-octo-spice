if @error_code != 0
  json.error code: @error_code, description: @error_description
else
  json.bet do
    json.ticket_number @bet["ticketNumber"] rescue nil
    json.ref_number @bet["refNumber"] rescue nil
    json.transaction_id @transaction_id rescue nil
    json.audit_number @bet["auditNumber"] rescue nil
    json.bet_cost_amount @bet["betCostAmount"] rescue nil
    json.bet_payout_amount @bet["betPayoutAmount"] rescue nil
    json.bet_code @bet["betCode"] rescue nil
    json.bet_modifier @bet["betModifier"] rescue nil
    json.selector1 @bet["selector1"] rescue nil
    json.selector2 @bet["selector2"] rescue nil
    json.repeats @bet["repeats"] rescue nil
    json.special_entries @bet["specialEntries"].to_s.sub("\n", "") rescue nil
    json.normal_entries @bet["normalEntries"].to_s.sub("\n", "") rescue nil
  end
end
