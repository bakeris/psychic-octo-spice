if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.bets @bets_list do |bet|
    json.code bet.at('CodBet').content
    json.description bet.at('Description').content
    json.is_live bet.at('IsLive').content
    json.is_handicap bet.at('IsHandicap').content
    json.is_static bet.at('IsStatic').content
    json.kind_handicap bet.at('KindHandicap').content
    json.num_draw bet.at('NumDraw').content
    json.draws bet.xpath('Draw') do |draw|
      json.code draw.at('CodDraw').content
      json.acronym draw.at('Acronym').content
      json.description draw.at('Description').content
      json.status draw.at('Status').content
    end
  end
end
