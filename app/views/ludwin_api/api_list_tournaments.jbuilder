if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.tournaments @tournaments_list do |tournament|
    json.tournament_code tournament.at('CodTournament').content
    json.sport_code tournament.at('CodSport').content
    json.acronym tournament.at('Acronym').content
    json.description tournament.at('Description').content
  end
end
