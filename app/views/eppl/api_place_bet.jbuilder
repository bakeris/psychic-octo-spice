if @error_code != 0
  json.error code: @error_code, description: @error_description
else
  json.bet do
    json.paymoney_account_number @eppl.paymoney_account_number
    json.transaction_id @eppl.transaction_id
    json.transaction_amount @eppl.transaction_amount
  end
end
