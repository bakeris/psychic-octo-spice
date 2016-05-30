class LudwinApiController < ApplicationController
  @@url = 'https://services.sports4africa.com/Ussd' # prod
  #@@url = 'https://test.sports4africa.com/testUSSD' # test

  @@license_code = '299'
  #@@license_code = '6951' #prod
  @@point_of_sale_code = '595'
  #@@point_of_sale_code = '138889' #prod
  @@terminal_id = '201'

  def api_list_sports
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = "#{@@url}/getSport"
    language = 'FR'
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    body = %Q[<?xml version="1.0" encoding="UTF-8"?>
              <ServicesPSQF>
	              <SportRequest>
		              <TransactionID>#{transaction_id}</TransactionID>
                  <Language>#{language}</Language>
	              </SportRequest>
              </ServicesPSQF>]
=begin
    response = %Q[<?xml version="1.0" encoding="UTF-8"?>
                  <ServicesPSQF>
	                  <SportResponse>
		                  <ReturnCode>
			                  <Code>0</Code>
			                  <Description>ESITO OK</Description>
			                  <FlgRetry>false</FlgRetry>
		                  </ReturnCode>
		                  <Sport>
			                  <CodSport>1</CodSport>
			                  <Acronym>CALCIO</Acronym>
			                  <Description>CALCIO</Description>
			                  <FlagComplementare>false</FlagComplementare>
		                  </Sport>
		                  <Sport>
			                  <CodSport>2</CodSport>
			                  <Acronym>BASKET</Acronym>
			                  <Description>BASKET</Description>
			                  <FlagComplementare>false</FlagComplementare>
		                  </Sport>
		                  <TransactionID>1393843550244</TransactionID>
	                  </SportResponse>
                  </ServicesPSQF>]
=end

    request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

    request.on_complete do |response|
      if response.success?
        response_body = response.body
        nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

        if !nokogiri_response.blank?
          response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
          if response_code == '0' || response_code == '1024'
            @sports_list = (nokogiri_response.xpath('//Sport') rescue nil)
          else
            @error_code = response_code
            @error_description = nokogiri_response.xpath('//ReturnCode').at('Description').content rescue ""
          end
        else
          @error_code = '4001'
          @error_description = 'Error while parsing XML.'
        end
      else
        @error_code = '4000'
        @error_description = 'Unavailable resource.'
      end
    end

    request.run

    #LudwinLog.create(operation: 'Liste complète des sports', transaction_id: transaction_id, language: language, error_code: @error_code, sent_body: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_show_sport
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = "#{@@url}/getSport"
    sport_code = params[:sport_code]
    language = 'FR'
    @error_code = ''
    @error_description = ''
    response_body = ''
    body = %Q[<?xml version="1.0" encoding="UTF-8"?>
              <ServicesPSQF>
	              <SportRequest>
		              <TransactionID>#{transaction_id}</TransactionID>
		              <CodSport>#{sport_code}</CodSport>
                  <Language>#{language}</Language>
	              </SportRequest>
              </ServicesPSQF>]
=begin
    response = %Q[<?xml version="1.0" encoding="UTF-8"?>
                  <ServicesPSQF>
	                  <SportResponse>
		                  <ReturnCode>
			                  <Code>0</Code>
			                  <Description>ESITO OK</Description>
			                  <FlgRetry>false</FlgRetry>
		                  </ReturnCode>
		                  <Sport>
			                  <CodSport>1</CodSport>
			                  <Acronym>CALCIO</Acronym>
			                  <Description>CALCIO</Description>
			                  <FlagComplementare>false</FlagComplementare>
		                  </Sport>
		                  <Sport>
			                  <CodSport>2</CodSport>
			                  <Acronym>BASKET</Acronym>
			                  <Description>BASKET</Description>
			                  <FlagComplementare>false</FlagComplementare>
		                  </Sport>
		                  <TransactionID>1393843550244</TransactionID>
	                  </SportResponse>
                  </ServicesPSQF>]
=end
    request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

    request.on_complete do |response|
      if response.success?
        response_body = response.body
        nokogiri_response = (Nokogiri.XML(response_body) rescue nil)

        if !nokogiri_response.blank?
          response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
          if response_code == '0' || response_code == '1024'
            @sports_list = (nokogiri_response.xpath('//Sport') rescue nil)
          else
            @error_code = response_code
            @error_description = nokogiri_response.xpath('//ReturnCode').at('Description').content rescue ""
          end
        else
          @error_code = '4001'
          @error_description = 'Error while parsing XML.'
        end
      else
        @error_code = '4000'
        @error_description = 'Unavailable resource.'
      end
    end

    request.run

    LudwinLog.create(operation: "Affichage d'un sport spécifique", transaction_id: transaction_id, language: language, error_code: @error_code, sent_body: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_list_tournaments
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = "#{@@url}/getTournament"
    sport_code = params[:sport_code]
    language = 'FR'
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    body = %Q[<?xml version="1.0" encoding="UTF-8"?>
              <ServicesPSQF>
	              <TournamentRequest>
	                <CodSport>#{sport_code}</CodSport>
		              <TransactionID>#{transaction_id}</TransactionID>
	              </TournamentRequest>
              </ServicesPSQF>]
=begin
    response = %Q[<?xml version="1.0" encoding="UTF-8"?>
                  <ServicesPSQF>
	                  <SportResponse>
		                  <ReturnCode>
			                  <Code>0</Code>
			                  <Description>ESITO OK</Description>
			                  <FlgRetry>false</FlgRetry>
		                  </ReturnCode>
		                  <Sport>
			                  <CodSport>1</CodSport>
			                  <Acronym>CALCIO</Acronym>
			                  <Description>CALCIO</Description>
			                  <FlagComplementare>false</FlagComplementare>
		                  </Sport>
		                  <Sport>
			                  <CodSport>2</CodSport>
			                  <Acronym>BASKET</Acronym>
			                  <Description>BASKET</Description>
			                  <FlagComplementare>false</FlagComplementare>
		                  </Sport>
		                  <TransactionID>1393843550244</TransactionID>
	                  </SportResponse>
                  </ServicesPSQF>]
=end

    request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

    request.on_complete do |response|
      if response.success?
        response_body = response.body
        nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

        if !nokogiri_response.blank?
          response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
          if response_code == '0' || response_code == '1024'
            @tournaments_list = (nokogiri_response.xpath('//Tournament') rescue nil)
          else
            @error_code = response_code
            @error_description = nokogiri_response.xpath('//ReturnCode').at('Description').content rescue ""
          end
        else
          @error_code = '4001'
          @error_description = 'Error while parsing XML.'
        end
      else
        @error_code = '4000'
        @error_description = 'Unavailable resource.'
      end
    end

    request.run

    LudwinLog.create(operation: 'Liste complète des tournois', transaction_id: transaction_id, language: language, error_code: @error_code, sent_body: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_show_tournament
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = "#{@@url}/getTournament"
    language = 'FR'
    sport_code = params[:sport_code]
    tournament_code = params[:tournament_code]
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    body = %Q[<?xml version="1.0" encoding="UTF-8"?>
              <ServicesPSQF>
	              <TournamentRequest>
	                <CodSport>#{sport_code}</CodSport>
		              <CodTournament>#{tournament_code}</CodTournament>
		              <TransactionID>#{transaction_id}</TransactionID>
                  <Language>#{language}</Language>
	              </TournamentRequest>
              </ServicesPSQF>]
=begin
    response = %Q[<?xml version="1.0" encoding="UTF-8"?>
                  <ServicesPSQF>
	                  <SportResponse>
		                  <ReturnCode>
			                  <Code>0</Code>
			                  <Description>ESITO OK</Description>
			                  <FlgRetry>false</FlgRetry>
		                  </ReturnCode>
		                  <Sport>
			                  <CodSport>1</CodSport>
			                  <Acronym>CALCIO</Acronym>
			                  <Description>CALCIO</Description>
			                  <FlagComplementare>false</FlagComplementare>
		                  </Sport>
		                  <Sport>
			                  <CodSport>2</CodSport>
			                  <Acronym>BASKET</Acronym>
			                  <Description>BASKET</Description>
			                  <FlagComplementare>false</FlagComplementare>
		                  </Sport>
		                  <TransactionID>1393843550244</TransactionID>
	                  </SportResponse>
                  </ServicesPSQF>]
=end

    request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

    request.on_complete do |response|
      if response.success?
        response_body = response.body
        nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

        if !nokogiri_response.blank?
          response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
          if response_code == '0' || response_code == '1024'
            @tournaments_list = (nokogiri_response.xpath('//Tournament') rescue nil)
          else
            @error_code = response_code
            @error_description = nokogiri_response.xpath('//ReturnCode').at('Description').content rescue ""
          end
        else
          @error_code = '4001'
          @error_description = 'Error while parsing XML.'
        end
      else
        @error_code = '4000'
        @error_description = 'Unavailable resource.'
      end
    end

    request.run

    LudwinLog.create(operation: 'Liste complète des tournois', transaction_id: transaction_id, language: language, error_code: @error_code, sent_body: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_list_prematch_data
    remote_ip_address = request.remote_ip
    language = 'FR'
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    url = "#{@@url}/getEvent?system_code=PD&type=FULL&isLive=0&len=#{language}"

    request = Typhoeus::Request.new(url, followlocation: true, method: :get, ssl_verifypeer: false, ssl_verifyhost: 0)

    request.on_complete do |response|
      if response.success?
        response_body = response.body
        @sports_list = (Nokogiri::XML(response_body).xpath('//SportMobile') rescue nil)

        if @sports_list.blank?
          @error_code = '4001'
          @error_description = 'Error while parsing XML.'
        end
      else
        @error_code = '4000'
        @error_description = 'Unavailable resource.'
      end
    end

    request.run

    #LudwinLog.create(operation: "Liste complète des données d'avant match", transaction_id: transaction_id, language: language, error_code: @error_code, response_body: response_body, remote_ip_address: remote_ip_address)
  end

   def api_list_live_data
    remote_ip_address = request.remote_ip
    language = 'FR'
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    url = "#{@@url}/getEvent?system_code=PD&type=FULL&isLive=1&len=#{language}"

    request = Typhoeus::Request.new(url, followlocation: true, method: :get, ssl_verifypeer: false, ssl_verifyhost: 0)

    request.on_complete do |response|
      if response.success?
        response_body = response.body
        @sports_list = (Nokogiri::XML(response_body).xpath('//SportMobile') rescue nil)

        if @sports_list.blank?
          @error_code = '4001'
          @error_description = 'Error while parsing XML.'
        end
      else
        @error_code = '4000'
        @error_description = 'Unavailable resource.'
      end
    end

    request.run

    #LudwinLog.create(operation: "Liste complète des données d'avant match", transaction_id: transaction_id, language: language, error_code: @error_code, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_list_prematch_data_delta
    remote_ip_address = request.remote_ip
    language = 'FR'
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    url = "#{@@url}/getEvent?system_code=PD&type=DELTA&isLive=0&len=#{language}"

    request = Typhoeus::Request.new(url, followlocation: true, method: :get, ssl_verifypeer: false, ssl_verifyhost: 0)

    request.on_complete do |response|
      if response.success?
        @response_body = response.body
        #@sports_list = (Nokogiri::XML(@response_body).xpath('//SportMobile') rescue nil)

        if @sports_list.blank?
          @error_code = '4001'
          @error_description = 'Error while parsing XML.'
        end
      else
        @error_code = '4000'
        @error_description = 'Unavailable resource.'
      end
    end

    request.run

    #LudwinLog.create(operation: "Liste complète des données d'avant match", transaction_id: transaction_id, language: language, error_code: @error_code, response_body: response_body, remote_ip_address: remote_ip_address)
    render text: @response_body
  end

  def api_list_live_data_delta
    remote_ip_address = request.remote_ip
    language = 'FR'
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    url = "#{@@url}/getEvent?system_code=PD&type=DELTA&isLive=1&len=#{language}"

    request = Typhoeus::Request.new(url, followlocation: true, method: :get, ssl_verifypeer: false, ssl_verifyhost: 0)

    request.on_complete do |response|
      if response.success?
        @response_body = response.body
        #@sports_list = (Nokogiri::XML(@response_body).xpath('//SportMobile') rescue nil)

        if @sports_list.blank?
          @error_code = '4001'
          @error_description = 'Error while parsing XML.'
        end
      else
        @error_code = '4000'
        @error_description = 'Unavailable resource.'
      end
    end

    request.run

    #LudwinLog.create(operation: "Liste complète des données d'avant match", transaction_id: transaction_id, language: language, error_code: @error_code, response_body: response_body, remote_ip_address: remote_ip_address)
    render text: @response_body
  end

  def api_list_bets
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = "#{@@url}/getBet"
    language = 'FR'
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    body = %Q[<?xml version="1.0" encoding="UTF-8"?>
              <ServicesPSQF>
                <BetsRequest>
		              <TransactionID>#{transaction_id}</TransactionID>
                  <Language>#{language}</Language>
	              </BetsRequest>
              </ServicesPSQF>]

    request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

    request.on_complete do |response|
      if response.success?
        response_body = response.body
        nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

        if !nokogiri_response.blank?
          response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
          if response_code == '0' || response_code == '1024'
            @bets_list = (nokogiri_response.xpath('//Bet') rescue nil)
          else
            @error_code = response_code
            @error_description = nokogiri_response.xpath('//ReturnCode').at('Description').content rescue ""
          end
        else
          @error_code = '4001'
          @error_description = 'Error while parsing XML.'
        end
      else
        @error_code = '4000'
        @error_description = 'Unavailable resource.'
      end
    end

    request.run

    #LudwinLog.create(operation: 'Liste complète des paris', transaction_id: transaction_id, language: language, error_code: @error_code, sent_body: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_show_bet
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = "#{@@url}/getBet"
    language = 'FR'
    bet_code = params[:bet_code]
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    body = %Q[<?xml version="1.0" encoding="UTF-8"?>
              <ServicesPSQF>
                <BetsRequest>
                  <CodBet>#{bet_code}</CodBet>
		              <TransactionID>#{transaction_id}</TransactionID>
                  <Language>#{language}</Language>
	              </BetsRequest>
              </ServicesPSQF>]

    request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

    request.on_complete do |response|
      if response.success?
        response_body = response.body
        nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

        if !nokogiri_response.blank?
          response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
          if response_code == '0' || response_code == '1024'
            @bets_list = (nokogiri_response.xpath('//Bet') rescue nil)
          else
            @error_code = response_code
            @error_description = nokogiri_response.xpath('//ReturnCode').at('Description').content rescue ""
          end
        else
          @error_code = '4001'
          @error_description = 'Error while parsing XML.'
        end
      else
        @error_code = '4000'
        @error_description = 'Unavailable resource.'
      end
    end

    request.run

    LudwinLog.create(operation: "Affichage d'un pari spécifique", transaction_id: transaction_id, language: language, error_code: @error_code, sent_body: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_sell_coupon
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = "#{@@url}/doBet"
    license_code = '299'
    point_of_sale_code = '595'
    terminal_id = '201'
    account_id = 'scommessina31'
    account_type = '14'
    coupons_body = ''
    body = ''
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    coupons = (JSON.parse(request.body.read) rescue nil)
    amount = ''
    coupons_details = ''
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    paymoney_account_token = check_account_number(params[:paymoney_account_number])
    user = User.find_by_uuid(params[:gamer_id])
    gamer_id = params[:gamer_id]
    password = params[:password]

    if user.blank?
      @error_code = '3000'
      @error_description = "L'identifiant du parieur n'a pas été trouvé."
    else
      if !(coupons["bets"] rescue nil).blank?
        @amount = coupons["amount"].to_i rescue nil

        if @amount.blank?
          @error_code = '5001'
          @error_description = "Le montant des gains n'a pas pu être récupéré."
        else
          @bet = Bet.create(license_code: license_code, pos_code: point_of_sale_code, terminal_id: terminal_id, account_id: account_id, account_type: account_type, transaction_id: transaction_id, gamer_id: gamer_id, game_account_token: "LhSpwtyN", amount: @amount)
          coupons_body = format_coupouns(coupons["bets"])

            if coupons_body.blank?
              @error_code = '5003'
              @error_description = 'Veuillez prendre au moins un pari.'
            else
              body = %Q[<?xml version='1.0' encoding='UTF-8'?><ServicesPSQF><SellRequest><CodConc>#{license_code}</CodConc><CodDiritto>#{point_of_sale_code}</CodDiritto><IdTerminal>#{terminal_id}</IdTerminal><TransactionID>#{transaction_id}</TransactionID><AmountCoupon>#{@amount}</AmountCoupon><AmountWin>#{@win_amount}</AmountWin>#{coupons_body}</SellRequest></ServicesPSQF>]

              @bet.update_attributes(win_amount: @win_amount)

                if place_bet_without_cancellation(@bet, "LhSpwtyN", params[:paymoney_account_number], password, @amount)
                  request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "text/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)
                  request.on_complete do |response|
                    if response.success? || response.code == 417
                      response_body = response.body
                      nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

                      if !nokogiri_response.blank?
                        response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
                        if response_code == '0' || response_code == '1024'
                          @bet_info = (nokogiri_response.xpath('//SellResponse') rescue nil)
                          @bet.update_attributes(validated: true, validated_at: DateTime.now, ticket_id: (@bet_info.at('TicketSogei').content rescue nil), ticket_timestamp: (@bet_info.at('TimeStamp').content rescue nil))
                          @coupons = @bet.bet_coupons
                        else
                          @bet.update_attributes(validated: false, validated_at: DateTime.now)
                          @error_code = nokogiri_response.xpath('//ReturnCode').at('Code').content rescue ""
                          @error_description = nokogiri_response.xpath('//ReturnCode').at('Description').content rescue ""
                        end
                      else
                        @error_code = '4001'
                        @error_description = 'Erreur lors du parsing du XML.'
                      end
                    else
                      @error_code = '4000'
                      @error_description = 'Plateforme non disponible.'
                    end
                  end

                  request.run
                end

              LudwinLog.create(operation: "Prise de pari", transaction_id: transaction_id, error_code: @error_code, sent_body: body, response_body: response_body, remote_ip_address: remote_ip_address)
            end
          #end
        end
      else
        @error_code = '5000'
        @error_description = 'Invalid JSON data.'
      end
    end
  end

  def format_coupouns(coupons)
    tmp_coupons_body = ''
    @win_amount = @amount
    coupons.each do |coupon|
      pal_code = (coupon["pal_code"].to_s rescue "")
      event_code = (coupon["event_code"].to_s rescue "")
      bet_code = (coupon["bet_code"].to_s rescue "")
      draw_code = (coupon["draw_code"].to_s rescue "")
      odd = (coupon["odd"].to_s rescue "")
      amount = (coupon["amount"] rescue "")
      begin_date = (coupon["begin_date"] rescue "")
      teams = (coupon["teams"] rescue "")
      sport = (coupon["sport"] rescue "")
      @win_amount =   (@win_amount * ((odd.to_f rescue 0) / 100)).to_i rescue 0

      unless pal_code.blank? || event_code.blank? || bet_code.blank? || draw_code.blank? || odd.blank?
        @bet.bet_coupons.create(pal_code: pal_code, event_code: event_code, bet_code: bet_code, draw_code: draw_code, odd: odd, begin_date: begin_date, teams: teams, sport: sport)
        tmp_coupons_body << %Q[<BetCoupon><CodPal>#{pal_code}</CodPal><CodEvent>#{event_code}</CodEvent><CodBet>#{bet_code}</CodBet><CodDraw>#{draw_code}</CodDraw><Odd>#{odd}</Odd></BetCoupon>]
      end
    end

    return tmp_coupons_body
  end


  def api_m_sell_coupon
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = "#{@@url}/doBet"
    license_code = @@license_code
    point_of_sale_code = @@point_of_sale_code
    account_id = 'scommessina31'
    account_type = '14'
    coupons_body = ''
    body = ''
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    coupons = (JSON.parse(request.body.read) rescue nil)
    amount = ''
    coupons_details = ''
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    paymoney_account_number = params[:paymoney_account_number]
    paymoney_account_token = check_account_number(paymoney_account_number)
    user = User.find_by_uuid(params[:gamer_id])
    gamer_id = params[:gamer_id]
    password = params[:password]

    if user.blank?
      @error_code = '3000'
      @error_description = "L'identifiant du parieur n'a pas été trouvé."
    else
      # Lock the terminal
      unless terminal_selected
        @error_code = '3001'
        @error_description = "Veuillez réessayer."
      else
        if !(coupons["bets"] rescue nil).blank?
          @amount = coupons["amount"].to_i rescue nil
          formula = coupons["formula"] rescue nil

          if @amount.blank?
            @error_code = '5001'
            @error_description = "Le montant des gains n'a pas pu être récupéré."
          else
            @bet = Bet.create(license_code: license_code, pos_code: point_of_sale_code, terminal_id: @terminal.code, account_id: account_id, account_type: account_type, transaction_id: transaction_id, gamer_id: gamer_id, game_account_token: "LhSpwtyN", amount: @amount, formula: formula, paymoney_account_number: paymoney_account_number)
            coupons_body = format_coupouns(coupons["bets"])

            if coupons_body.blank?
              @error_code = '5003'
              @error_description = 'Veuillez prendre au moins un pari.'
            else
              terminal_id = @terminal.code

              body = %Q[<?xml version='1.0' encoding='UTF-8'?><ServicesPSQF><SellRequest><CodConc>#{license_code}</CodConc><CodDiritto>#{point_of_sale_code}</CodDiritto><IdTerminal>#{@terminal.code}</IdTerminal><TransactionID>#{transaction_id}</TransactionID><AmountCoupon>#{@amount}</AmountCoupon><AmountWin>#{@win_amount}</AmountWin>#{coupons_body}</SellRequest></ServicesPSQF>]

              @bet.update_attributes(win_amount: @win_amount)

              # débit du compte paymoney
              #if place_bet_without_cancellation(@bet, "LhSpwtyN", params[:paymoney_account_number], password, @amount)
              # Vérification du solde Paymoney
              @url = "http://94.247.178.141:8080/PAYMONEY_WALLET/rest/solte_compte/#{paymoney_account_number}/#{password}"
              sold = JSON.parse((RestClient.get @url rescue ""))
              sold = sold["solde"].to_f
              if sold >= @amount.to_f

                request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "text/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0, timeout: 15)

                request.on_complete do |response|
                  if response.success? || response.code == 417
                    response_body = response.body
                    nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

                    # Free the terminal
                    @terminal.update_attributes(busy: false)

                    if !nokogiri_response.blank?
                      response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
                      if response_code == '0' || response_code == '1024'
                        @bet_info = (nokogiri_response.xpath('//SellResponse') rescue nil)
                        # débit du compte paymoney
                        if place_bet_without_cancellation(@bet, "LhSpwtyN", params[:paymoney_account_number], password, @amount)
                          ticket_status = true
                          bet_status = 'En cours'
                        else
                          ticket_status = false
                          bet_status = nil
                        end
                        @bet.update_attributes(validated: ticket_status, validated_at: DateTime.now, ticket_id: (@bet_info.at('TicketSogei').content rescue nil), ticket_timestamp: (@bet_info.at('TimeStamp').content rescue nil), bet_status: bet_status)
                        @coupons = @bet.bet_coupons
                      else
                        # Remboursement tu ticket en cas d'erreur chez Ludwin
                        #payback_unplaced_bet(@bet)
                        @bet.update_attributes(validated: false, validated_at: DateTime.now)
                        @error_code = nokogiri_response.xpath('//ReturnCode').at('Code').content rescue ""
                        @error_description = nokogiri_response.xpath('//ReturnCode').at('Description').content rescue ""
                      end
                    else
                      # Free the terminal
                      @terminal.update_attributes(busy: false)

                      @error_code = '4001'
                      @error_description = 'Erreur lors du parsing du XML.'
                    end
                  else
                    @error_code = '4000'
                    @error_description = 'Plateforme non disponible.'
                  end
                end

                request.run
              else
                @error_code = '5005'
                @error_description = 'Veuillez vérifier votre compte et votre solde.'
              end

              LudwinLog.create(operation: "Prise de pari", transaction_id: (@terminal.code rescue ""), error_code: @error_code, sent_body: body, response_body: response_body, remote_ip_address: remote_ip_address)
            end
            #end
          end
        else
          @error_code = '5000'
          @error_description = 'Invalid JSON data.'
        end


      end
    end
  end

  def api_system_bet_placement
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = "#{@@url}/doBet"
    license_code = @@license_code
    point_of_sale_code = @@point_of_sale_code
    account_id = 'scommessina31'
    account_type = '14'
    coupons_body = ''
    body = ''
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    coupons = (JSON.parse(request.body.read) rescue nil)
    amount = ''
    coupons_details = ''
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    paymoney_account_number = params[:paymoney_account_number]
    paymoney_account_token = check_account_number(paymoney_account_number)
    user = User.find_by_uuid(params[:gamer_id])
    gamer_id = params[:gamer_id]
    password = params[:password]

    if user.blank?
      @error_code = '3000'
      @error_description = "L'identifiant du parieur n'a pas été trouvé."
    else
      # Lock the terminal
      unless terminal_selected
        @error_code = '3001'
        @error_description = "Veuillez réessayer."
      else
        if !(coupons["bets"] rescue nil).blank?
          @amount = coupons["amount"].to_i rescue nil
          formula = coupons["formula"] rescue nil
          system_code = coupons["system_code"] rescue nil
          number_of_combinations = coupons["number_of_combinations"] rescue nil

          if @amount.blank?
            @error_code = '5001'
            @error_description = "Le montant des gains n'a pas pu être récupéré."
          else
            @bet = Bet.create(license_code: license_code, pos_code: point_of_sale_code, terminal_id: @terminal.code, account_id: account_id, account_type: account_type, transaction_id: transaction_id, gamer_id: gamer_id, game_account_token: "LhSpwtyN", amount: @amount, formula: formula, paymoney_account_number: paymoney_account_number, system_code: system_code, number_of_combinations: number_of_combinations)

            coupons_body = format_system_coupouns(coupons["bets"])

            if coupons_body.blank?
              @error_code = '5003'
              @error_description = 'Veuillez prendre au moins un pari.'
            else
              terminal_id = @terminal.code

              body = %Q[<?xml version='1.0' encoding='UTF-8'?><ServicesPSQF><SellSystemRequest><CodConc>#{license_code}</CodConc><CodDiritto>#{point_of_sale_code}</CodDiritto><IdTerminal>#{@terminal.code}</IdTerminal><TransactionID>#{transaction_id}</TransactionID><AmountCoupon>#{@win_amount}</AmountCoupon><System><Code>#{system_code}</Code><Amount>#{@amount}</Amount><Num_Multiple>#{number_of_combinations}</Num_Multiple></System>#{coupons_body}</SellSystemRequest></ServicesPSQF>]

              @bet.update_attributes(win_amount: @win_amount)

              # débit du compte paymoney
              #if place_bet_without_cancellation(@bet, "LhSpwtyN", params[:paymoney_account_number], password, @amount)
              # Vérification du solde Paymoney
              @url = "http://94.247.178.141:8080/PAYMONEY_WALLET/rest/solte_compte/#{paymoney_account_number}/#{password}"
              sold = JSON.parse((RestClient.get @url rescue ""))
              sold = sold["solde"].to_f
              if sold >= @amount.to_f

                request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "text/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0, timeout: 15)

                request.on_complete do |response|
                  if response.success? || response.code == 417
                    response_body = response.body
                    nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

                    # Free the terminal
                    @terminal.update_attributes(busy: false)

                    if !nokogiri_response.blank?
                      response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
                      if response_code == '0' || response_code == '1024'
                        @bet_info = (nokogiri_response.xpath('//SellResponse') rescue nil)
                        # débit du compte paymoney
                        if place_bet_without_cancellation(@bet, "LhSpwtyN", params[:paymoney_account_number], password, @amount)
                          ticket_status = true
                          bet_status = 'En cours'
                        else
                          ticket_status = false
                          bet_status = nil
                        end
                        @bet.update_attributes(validated: ticket_status, validated_at: DateTime.now, ticket_id: (@bet_info.at('TicketSogei').content rescue nil), ticket_timestamp: (@bet_info.at('TimeStamp').content rescue nil), bet_status: bet_status)
                        @coupons = @bet.bet_coupons
                      else
                        # Remboursement tu ticket en cas d'erreur chez Ludwin
                        #payback_unplaced_bet(@bet)
                        @bet.update_attributes(validated: false, validated_at: DateTime.now)
                        @error_code = nokogiri_response.xpath('//ReturnCode').at('Code').content rescue ""
                        @error_description = nokogiri_response.xpath('//ReturnCode').at('Description').content rescue ""
                      end
                    else
                      # Free the terminal
                      @terminal.update_attributes(busy: false)

                      @error_code = '4001'
                      @error_description = 'Erreur lors du parsing du XML.'
                    end
                  else
                    @error_code = '4000'
                    @error_description = 'Plateforme non disponible.'
                  end
                end

                request.run
              else
                @error_code = '5005'
                @error_description = 'Veuillez vérifier votre compte et votre solde.'
              end

              LudwinLog.create(operation: "Prise de pari", transaction_id: (@terminal.code rescue ""), error_code: @error_code, sent_body: body, response_body: response_body, remote_ip_address: remote_ip_address)
            end
            #end
          end
        else
          @error_code = '5000'
          @error_description = 'Invalid JSON data.'
        end
      end
    end
  end

  def api_last_request_log
    @previous_operation = LudwinLog.find(LudwinLog.last.id - 1) rescue ""
    @last_operation = LudwinLog.last rescue ""

    render text: "---Operation: " + (@previous_operation.operation || "") + "\n\n---Transaction ID: " +  (@previous_operation.transaction_id || "") + "\n\n---Sent params: " +  (@previous_operation.sent_body || "") + "\n\n---Response: " +  (@previous_operation.response_body || "") + "\n\n\n\n---Operation: " + (@last_operation.operation || "") + "\n\n---Transaction ID: " + (@last_operation.transaction_id || "") + "\n\n---Sent params: " + (@last_operation.sent_body || "") + "\n\n---Response: " + (@last_operation.response_body || "")
  end

  def format_system_coupouns(coupons)
    tmp_coupons_body = ''
    @win_amount = @amount
    coupons.each do |coupon|
      pal_code = (coupon["pal_code"].to_s rescue "")
      event_code = (coupon["event_code"].to_s rescue "")
      is_fix = (coupon["is_fix"].to_s rescue "")
      bet_code = (coupon["bet_code"].to_s rescue "")
      handicap = (coupon["handicap"].to_s rescue "")
      draw_code = (coupon["draw_code"].to_s rescue "")
      odd = (coupon["odd"].to_s rescue "")
      begin_date = (coupon["begin_date"] rescue "")
      teams = (coupon["teams"] rescue "")
      sport = (coupon["sport"] rescue "")
      @win_amount =   (@win_amount * ((odd.to_f rescue 0) / 100)).to_i rescue 0

      unless pal_code.blank? || event_code.blank? || bet_code.blank? || draw_code.blank? || odd.blank?
        @bet.bet_coupons.create(pal_code: pal_code, event_code: event_code, bet_code: bet_code, draw_code: draw_code, odd: odd, begin_date: begin_date, teams: teams, sport: sport, is_fix: is_fix, handicap: handicap, flag_bonus: "0")
        tmp_coupons_body << %Q[<SystemEvent><CodPal>#{pal_code}</CodPal><CodEvent>#{event_code}</CodEvent><IsFix>#{is_fix}</IsFix><SystemBet><CodBet>#{bet_code}</CodBet><Handicap>#{handicap}</Handicap><SystemDraw><CodDraw>#{draw_code}</CodDraw><Odd>#{odd}</Odd><FlagBonus>0</FlagBonus></SystemDraw></SystemBet></SystemEvent>]
      end
    end

    return tmp_coupons_body
  end


  def terminal_selected
    status = false
    @terminal = SpcTerminal.where("busy IS NOT TRUE").first rescue nil

    unless @terminal.blank?
      @terminal.update_attributes(busy: true)
      status = true
    end

    return status
  end


  def api_cancel_coupon
    remote_ip_address = request.remote_ip
    url = "#{@@url}/cancelBet"
     license_code = @@license_code
    point_of_sale_code = @@point_of_sale_code
    #terminal_id = @@terminal_id
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    ticket_id = params[:ticket_id]
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    @bet = Bet.where("ticket_id = '#{ticket_id}' AND validated IS TRUE")

    if @bet.blank?
      @error_code = '5000'
      @error_description = 'The ticket ID could not be found.'
    else
      # Lock the terminal
      unless terminal_selected
        @error_code = '3001'
        @error_description = "Veuillez réessayer."
      else
        body = %Q[<?xml version="1.0" encoding="UTF-8"?>
                <ServicesPSQF>
                  <CancelRequest>
                    <CodConc>#{license_code}</CodConc>
		                <CodDiritto>#{point_of_sale_code}</CodDiritto>
		                <IdTerminal>#{@terminal.code}</IdTerminal>
		                <TransactionID>#{transaction_id}</TransactionID>
		                <TicketID>#{ticket_id}</TicketID>
	                </CancelRequest>
                </ServicesPSQF>]
        request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

        request.on_complete do |response|
          if response.success?
            response_body = response.body
            nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

            if !nokogiri_response.blank?
              response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
              if response_code == '0' || response_code == '1024'
                if cancel_bet(@bet.first)
                  @bet.first.update_attributes(cancelled: true, cancelled_at: DateTime.now, bet_status: "Annulé")
                  @bet_cancellation_result = (nokogiri_response.xpath('//CancelResponse') rescue nil)
                end
              else
                @bet.first.update_attributes(cancelled: false, cancelled_at: DateTime.now)
                @error_code = response_code
                @error_description = nokogiri_response.xpath('//ReturnCode').at('Description').content rescue ""
              end
            else
              @error_code = '4001'
              @error_description = 'Error while parsing XML.'
            end
          else
            @error_code = '4000'
            @error_description = 'Unavailable resource.'
          end
        end

        request.run

        # Free the terminal
        @terminal.update_attributes(busy: false)
      end
    end

    LudwinLog.create(operation: "Annulation de pari", transaction_id: @transaction_id, error_code: @error_code, sent_body: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  # 102- Generic error
  def api_coupon_payment_notification
    @error_code = ''
    @error_description = ''
    remote_ip_address = request.remote_ip
    license_code = @@license_code
    point_of_sale_code = @@point_of_sale_code
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = "#{@@url}/paymentTicket"
    payment_notification_envelope = (Nokogiri::XML(request.body.read) rescue nil)
    LudwinLog.create(operation: "Paiement de coupon", response_body: request.body.read, remote_ip_address: remote_ip_address)

    unless terminal_selected
      @error_code = '3001'
      @error_description = "Veuillez réessayer."
    else
      if payment_notification_envelope.blank?
        @error_code = '5000'
        @error_description = 'Invalid XML data.'
      else
        ticket_id = (payment_notification_envelope.xpath('//PaymentNotificationRequest').at('TicketSogei').content rescue nil)
        pn_transaction_id = (payment_notification_envelope.xpath('//PaymentNotificationRequest').at('TransactionID').content rescue nil)

        @bet = Bet.where(ticket_id: ticket_id, transaction_id: pn_transaction_id)

        if @bet.blank?
          @error_code = '5001'
          @error_description = 'The coupon could not be found.'
        else
          @bet = @bet.first

          if @bet.bet_status != "En cours" #!@bet.pn_ticket_status.blank?
            @error_code = '5002'
            @error_description = 'Ce coupon a déja été validé.'
          else
            pn_ticket_status = (payment_notification_envelope.xpath('//PaymentNotificationRequest').at('StatusTicket').content rescue nil)
            pn_timestamp = (payment_notification_envelope.xpath('//PaymentNotificationRequest').at('TimeStamp').content rescue nil)
            pn_amount_win = (payment_notification_envelope.xpath('//PaymentNotificationRequest').at('AmountWin').content rescue nil)
            #pn_type_result = (payment_notification_envelope.xpath('//Result').at('TypeResult').content rescue nil)
            #pn_winning_value = (payment_notification_envelope.xpath('//Result/Winning').at('Value').content rescue nil)
            #pn_winning_position = (payment_notification_envelope.xpath('//Result/Winning').at('Position').content rescue nil)

            if ['1', '2', '3'].include?(pn_ticket_status)
              @bet.update_attributes(pn_ticket_status: pn_ticket_status, pn_amount_win: pn_amount_win, pn_transaction_id: pn_transaction_id, pn_timestamp: pn_timestamp)
              @error_code = '0'
              @error_description = 'OK'

              if pn_ticket_status == '1'
                body = %Q[<?xml version="1.0" encoding="UTF-8"?><ServicesPSQF><PaymentRequest><CodConc>#{license_code}</CodConc><CodDiritto>#{point_of_sale_code}</CodDiritto><IdTerminal>#{@terminal.code}</IdTerminal><TransactionID>#{transaction_id}</TransactionID><TicketSogei>#{ticket_id}</TicketSogei></PaymentRequest></ServicesPSQF>]

                request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "text/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

                request.on_complete do |response|
                  if response.success?
                    response_body = response.body
                    #response_body = %Q[<?xml version="1.0" encoding="UTF-8"?><ServicesPSQF><PaymentResponse><ReturnCode><Code>0</Code><Description>OK</Description><FlgRetry>false</FlgRetry></ReturnCode></PaymentResponse></ServicesPSQF>]
                    nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

                    if !nokogiri_response.blank?
                      response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
                      if response_code == '0' || response_code == '1024' || response_code == '5174' || response_code == '-1024' || response_code == '-5174' || response_code == '-0'
                        @sill_amount = Parameters.first.sill_amount rescue 0

                        if (@bet.win_amount.to_f rescue 0) > @sill_amount
                          @bet.update_attributes(payment_status_datetime: DateTime.now, bet_status: "Vainqueur en attente de paiement")
                          send_winning_notification
                        else
                          # Paymoney payment
                          if pay_earnings(@bet, "LhSpwtyN", @bet.win_amount)
                            @bet.update_attributes(pr_status: true, payment_status_datetime: DateTime.now, pr_transaction_id: transaction_id, bet_status: "Gagnant")
                            send_winning_notification
                          end
                        end

                        # SMS notification
                        #build_message(@bet, @bet.win_amount, "à SPORTCASH", @bet.ticket_id)
                        #send_sms_notification(@bet, @msisdn, "SPORTCASH", @message_content)

                        # Email notification
                        #WinningNotification.notification_email(@user, @bet.win_amount, "à SPORTCASH", "SPORTCASH", @bet.ticket_id, @bet.paymoney_account_number, '').deliver
                      else
                        if response_code == '5177' || response_code == '-5177'
                          @bet.update_attributes(pr_status: false, payment_status_datetime: DateTime.now, pr_transaction_id: transaction_id, bet_status: "Perdant")
                        end
                        @error_code = response_code
                        @error_description = nokogiri_response.xpath('//ReturnCode').at('Description').content rescue ""
                      end
                    else
                      @error_code = '4001'
                      @error_description = 'Error while parsing XML.'
                    end
                  else
                    @error_code = '4000'
                    @error_description = 'Unavailable resource.'
                  end
                  LudwinLog.create(operation: "Paiement de coupon", response_body: response_body, remote_ip_address: remote_ip_address, sent_body: body)
                end

                request.run


              end
            else
              @error_code = '5003'
              @error_description = 'Invalid notification status.'
            end

            @bet.update_attributes(error_code: @error_code, error_description: @error_description)
          end
        end
      end
    end

    # Free the terminal
    @terminal.update_attributes(busy: false)

    body = %Q[<?xml version="1.0" encoding="UTF-8"?>
              <ServicesPSQF>
                <PaymentNotificationResponse>
                  <ReturnCode>
			              <Code>#{@error_code}</Code>
			              <Description>#{@error_description}</Description>
			              <FlgRetry>false</FlgRetry>
		              </ReturnCode>
		              <TransactionID>#{transaction_id}</TransactionID>
	              </PaymentNotificationResponse>
              </ServicesPSQF>]

    render text: body
  end

  def periodically_validate_bet
    error_code = ''
    error_description = ''
    license_code = @@license_code
    point_of_sale_code = @@point_of_sale_code
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    payment_url = "#{@@url}/paymentTicket"
    unvalidated_bets =  Bet.where("bet_status = 'En cours' AND created_at > '#{Date.today - 15.day}'").pluck(:ticket_id).join(',') rescue ''
    status_message = ''
    url = "http://monaco.sports4africa.com/exabet/tickets_parionsdirect.cfm?liste_ticket_id=" + unvalidated_bets

    unless unvalidated_bets.blank?
      request = Typhoeus::Request.new(url, followlocation: true, method: :get)
      print unvalidated_bets
      request.on_complete do |response|
        if response.success?
          response_body = response.body
          status_message = response_body
          nokogiri_response = (Nokogiri::XML(response_body) rescue nil)
          print response_body
          if !nokogiri_response.blank?
            @tickets_list = (nokogiri_response.xpath('//Ticket') rescue nil)
            @tickets_list.each do |ticket|
              @bet = Bet.find_by_ticket_id(ticket.at('ID')) rescue nil
              if !@bet.blank?
                ticket_status = ticket.at('Statut')
                print ticket_status
                if ticket_status == 'PERDANT'
                  print 'PERDANT'
                  @bet.update_attributes(pr_status: false, payment_status_datetime: DateTime.now, pr_transaction_id: transaction_id, bet_status: "Perdant")
                end
                if ticket_status == 'PAYABLE'
                  print 'PAYABLE'
                  unless terminal_selected
                    status_message = "Terminal non disponible"
                    print 'Terminal non disponible'
                  else
                    body = %Q[<?xml version="1.0" encoding="UTF-8"?><ServicesPSQF><PaymentRequest><CodConc>#{license_code}</CodConc><CodDiritto>#{point_of_sale_code}</CodDiritto><IdTerminal>#{@terminal.code}</IdTerminal><TransactionID>#{transaction_id}</TransactionID><TicketSogei>#{ticket_id}</TicketSogei></PaymentRequest></ServicesPSQF>]

                    print body
                    request = Typhoeus::Request.new(payment_url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "text/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

                    request.on_complete do |response|
                      if response.success?
                        response_body = response.body
                        nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

                        if !nokogiri_response.blank?
                          response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
                          print response_code
                          if response_code == '0' || response_code == '1024' || response_code == '5174' || response_code == '-1024' || response_code == '-5174' || response_code == '-0'
                            sill_amount = Parameters.first.sill_amount rescue 0

                            if (@bet.win_amount.to_f rescue 0) > sill_amount
                              @bet.update_attributes(payment_status_datetime: DateTime.now, bet_status: "Vainqueur en attente de paiement")
                              send_winning_notification
                            else
                              # Paymoney payment
                              if pay_earnings(@bet, "LhSpwtyN", @bet.win_amount)
                                @bet.update_attributes(pr_status: true, payment_status_datetime: DateTime.now, pr_transaction_id: transaction_id, bet_status: "Gagnant")
                                send_winning_notification
                              end
                            end
                          else
                            if response_code == '5177' || response_code == '-5177'
                              @bet.update_attributes(pr_status: false, payment_status_datetime: DateTime.now, pr_transaction_id: transaction_id, bet_status: "Perdant")
                            end
                           status_message = nokogiri_response.xpath('//ReturnCode').at('Description').content rescue ""
                          end
                        else
                          status_message = 'Error while parsing XML.'
                        end
                      end
                    end

                    request.run

                    # Free the terminal
                    @terminal.update_attributes(busy: false)
                  end
                end
              end
            end
          else
            status_message = response_body
          end
        else
          status_message = "Ressource non disponible"
        end
      end

      request.run
    end

    LudwinLog.create(operation: "Validation périodique de coupons", response_body: status_message, sent_body: url)
  end

  def send_winning_notification
    # SMS notification
    build_message(@bet, @bet.win_amount, "à SPORTCASH", @bet.ticket_id)
    send_sms_notification(@bet, @msisdn, "SPORTCASH", @message_content)

    # Email notification
    WinningNotification.notification_email(@user, @bet.win_amount, "à SPORTCASH", "SPORTCASH", @bet.ticket_id, @bet.paymoney_account_number, '').deliver
  end

  def api_coupon_status
    @bet = Bet.find_by_transaction_id(params[:transaction_id])
    remote_ip_address = request.remote_ip
    @error_code = ''
    @error_description = ''

    if @bet.blank?
      @error_code = '4000'
      @error_description = 'Could not find the transaction ID.'
    end
  end

  def api_gamer_bets
    @error_code = ''
    @error_description = ''

    user = User.find_by_uuid(params[:gamer_id])

    if user.blank?
      @error_code = '4000'
      @error_description = 'The gamer id could not be found'
    else
      @bets = Bet.where("gamer_id = '#{params[:gamer_id]}' AND bet_status IS NOT NULL").order("created_at DESC")
    end
  end

  def terminals_status
    terminals = SpcTerminal.all
    status = ""

    unless terminals.blank?
      terminals.each do |terminal|
        status << "Code du terminal: " + terminal.code.to_s + " -- Statut: " + (terminal.busy == true ? "Occupé" : "Libre") + " -- Date du verrouillage: " + (terminal.updated_at.to_s rescue "") + "<br /><br />"
      end
    else
      status = "Aucun terminal trouvé"
    end

    render text: status.html_safe
  end

  def free_terminals
    SpcTerminal.all.update_all(busy: false)

    render text: "Les terminaux ont été libérés"
  end
end
