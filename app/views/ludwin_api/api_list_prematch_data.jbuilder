if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.sports @sports_list do |sport|
    json.code sport.at('CodeSport').content
    json.description sport.at('DescSport').content
    json.sport_languages sport.xpath('LanguageSport/Language') do |language|
      json.code language.at('LanguageCode').content
      json.description language.at('Description').content
    end
    json.tournaments sport.xpath('TournamentMobile') do |tournament|
      json.code tournament.at('CodeTournament').content
      json.description tournament.at('DescTournament').content
      json.tournament_languages tournament.xpath('LanguageTournament/Language') do |language|
        json.code language.at('LanguageCode').content
        json.description language.at('Description').content
      end
      json.events tournament.xpath('EventMobile') do |event|
        json.pal_code event.at('CodePal').content
        json.code event.at('CodEvent').content
        json.datetime event.at('TimeStamp').content
        json.description event.at('DescEvent').content
        json.event_languages event.xpath('LanguageEvent/Language') do |language|
          json.code language.at('LanguageCode').content
          json.description language.at('Description').content
        end
        json.id_bet_radar event.at('idBetradar').content
        json.op event.at('Op').content
        json.status event.at('Status').content
        json.market event.xpath('Market') do |market|
          json.bet_code market.at('CodeBet').content
          json.bet_description market.at('DescBet').content
          json.market_languages market.xpath('LanguageBet/Language') do |language|
            json.code language.at('LanguageCode').content
            json.description language.at('Description').content
          end
          json.handicap market.at('Handicap').content
          json.leg_aams market.at('LegAAMS').content
          json.leg_max market.at('LegMax').content
          json.leg_min market.at('LegMin').content
          json.live market.at('Live').content
          json.status market.at('Status').content
          json.market_draws market.xpath('MarketDraw') do |market_draw|
            json.code market_draw.at('CodeDraw').content
            json.description market_draw.at('DescDraw').content
            json.odd market_draw.at('Odd').content
            json.status market_draw.at('StatusDraw').content
            json.market_draws_languages market_draw.xpath('LanguageDraw/Language') do |language|
              json.code language.at('LanguageCode').content
              json.description language.at('Description').content
            end
          end
        end
      end
    end

  end
end
