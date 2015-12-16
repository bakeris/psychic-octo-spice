if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.game "EPPL"
  json.bet do
    json.transaction_id @eppl.transaction_id
    json.transaction_amount @eppl.transaction_amount
  end
end
