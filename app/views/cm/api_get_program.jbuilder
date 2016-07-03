if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.current_session do
    json.program_id @program_id
    json.type @type
    json.name @name
    json.program_date @program_date
    json.program_message @program_message
    json.program_number @program_number
    json.status @status
    json.race_ids @race_ids[0..(@race_ids.length - 2)]
  end
end
