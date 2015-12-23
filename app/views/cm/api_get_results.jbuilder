if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.results do
    json.rank_1 @rank_1
    json.rank_2 @rank_2
    json.rank_3 @rank_3
    json.rank_4 @rank_4
    json.rank_5 @rank_5
    json.rank_6 @rank_6
    json.scratched @scratched
  end
end
