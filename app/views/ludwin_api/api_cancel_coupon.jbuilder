if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.bet @bet_cancellation_result do |bet|
    json.transaction_id bet.at('TransactionID').content
    json.date_time bet.at('TimeStamp').content
    json.cancellation_status true
  end
end
