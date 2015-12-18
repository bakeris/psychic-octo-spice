if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.current_session do
    json.session_id @session_id
    json.session_date @session_date
    json.status @status
    json.currency_name @currency_name
    json.currency_mnemonic @currency_mnemonic
    json.program_id @program_id
  end
end
