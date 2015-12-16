if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.sport @sports_list do |sport|
    json.code sport.at('CodSport').content
    json.acronym sport.at('Acronym').content
    json.description sport.at('Description').content
  end
end
