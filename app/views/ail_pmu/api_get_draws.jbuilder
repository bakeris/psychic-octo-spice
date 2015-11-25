if @error_code != 0
  json.error code: @error_code, description: @error_description
else
  json.bet do
    json.transaction_id @bet.transaction_id rescue nil
    json.transaction_id @bet.transaction_id rescue nil
  end
end
