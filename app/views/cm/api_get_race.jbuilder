if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.race do
    json.program_id @program_id
    json.race_id @race_id
    json.name @name
    json.number @number
    json.close_time @close_time
    json.status @status
    json.max_runners @max_runners
    json.scratched_list @scrached_list[0..(@scrached_list.length - 2)]
    json.bet_ids @bet_ids[0..(@bet_ids.length - 2)]
  end
end
