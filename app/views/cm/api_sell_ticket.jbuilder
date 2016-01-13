if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.bet do
    json.transaction_id @transaction_id
    json.serial_number @serial_number
    json.amount @amount
  end
end
