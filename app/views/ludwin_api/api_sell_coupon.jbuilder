if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.bet @bet_info do |bet|
    json.ticket_id bet.at('TicketSogei').content
    json.date_time bet.at('TimeStamp').content
    json.transaction_id bet.at('TransactionID').content
  end
end
