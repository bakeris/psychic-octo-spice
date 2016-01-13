if @error_code != ""
  json.error code: @error_code, description: @error_description
else
  json.bet do
    #json.paymoney_account_number @eppl.paymoney_account_number
    json.earning_transaction_id @eppl.earning_transaction_id
    json.transaction_amount @eppl.transaction_amount
    json.begin_date @eppl.begin_date
    json.end_date @eppl.end_date
  end
end
