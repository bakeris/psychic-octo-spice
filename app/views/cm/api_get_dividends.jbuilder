if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.dividends @dividends
end
