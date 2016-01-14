if @error_code != ""
  json.error code: @error_code, description: @error_description
else
  json.bet do
    json.transaction_id @response_body
  end
end
