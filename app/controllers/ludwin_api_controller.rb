class LudwinApiController < ApplicationController

  def api_list_sports
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = 'https://sports4africa.com/testUSSD/getSport'
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
            @error_code = '4002'
            @error_description = 'Cannot retrieve the list of sports.'
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

    LudwinLog.create(operation: 'Liste complète des sports', transaction_id: transaction_id, language: language, error_code: @error_code, sent_body: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_show_sport
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = 'https://sports4africa.com/testUSSD/getSport'
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
            @error_code = '4002'
            @error_description = 'Cannot retrieve the list of sports.'
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
    url = 'https://sports4africa.com/testUSSD/getTournament'
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
            @error_code = '4002'
            @error_description = 'Cannot retrieve the list of tournaments.'
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
    url = 'https://sports4africa.com/testUSSD/getTournament'
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
            @error_code = '4002'
            @error_description = 'Cannot retrieve the list of tournaments.'
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
    url = "https://sports4africa.com/testUSSD/getEvent?system_code=PD&type=FULL&isLive=0&len=#{language}"

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

  def api_list_bets
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = 'https://sports4africa.com/testUSSD/getBet'
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
            @error_code = '4002'
            @error_description = 'Cannot retrieve the list of bets.'
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
    url = 'https://sports4africa.com/testUSSD/getBet'
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
            @error_code = '4002'
            @error_description = 'Cannot retrieve the list of bets.'
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
    url = 'https://sports4africa.com/testUSSD/doBet'
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

              print body

              @bet.update_attributes(win_amount: @win_amount)

              request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "text/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

              request.on_complete do |response|
                if response.success? || response.code == 417
                  response_body = response.body
                  nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

                  if !nokogiri_response.blank?
                    response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
                    if response_code == '0' || response_code == '1024'
                      if place_bet_without_cancellation(@bet, "LhSpwtyN", params[:paymoney_account_number], password, amount)
                        @bet_info = (nokogiri_response.xpath('//SellResponse') rescue nil)
                        @bet.update_attributes(validated: true, validated_at: DateTime.now, ticket_id: (@bet_info.at('TicketSogei').content rescue nil), ticket_timestamp: (@bet_info.at('TimeStamp').content rescue nil))
                        @coupons = @bet.bet_coupons
                      end
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
      @win_amount =   ((@win_amount * (odd.to_f / 100)).to_i )

      unless pal_code.blank? || event_code.blank? || bet_code.blank? || draw_code.blank? || odd.blank?
        @bet.bet_coupons.create(pal_code: pal_code, event_code: event_code, bet_code: bet_code, draw_code: draw_code, odd: odd)
        tmp_coupons_body << %Q[<BetCoupon><CodPal>#{pal_code}</CodPal><CodEvent>#{event_code}</CodEvent><CodBet>#{bet_code}</CodBet><CodDraw>#{draw_code}</CodDraw><Odd>#{odd}</Odd></BetCoupon>]
      end
    end

    return tmp_coupons_body
  end


  def api_m_sell_coupon
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = 'https://sports4africa.com/testUSSD/doBet'
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

              print body

              @bet.update_attributes(win_amount: @win_amount)

              request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "text/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

              request.on_complete do |response|
                if response.success? || response.code == 417
                  response_body = response.body
                  nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

                  if !nokogiri_response.blank?
                    response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
                    if response_code == '0' || response_code == '1024'
                      if place_bet_without_cancellation(@bet, "LhSpwtyN", params[:paymoney_account_number], password, @win_amount)
                        @bet_info = (nokogiri_response.xpath('//SellResponse') rescue nil)
                        @bet.update_attributes(validated: true, validated_at: DateTime.now, ticket_id: (@bet_info.at('TicketSogei').content rescue nil), ticket_timestamp: (@bet_info.at('TimeStamp').content rescue nil))
                        @coupons = @bet.bet_coupons
                      end
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


  def api_cancel_coupon
    remote_ip_address = request.remote_ip
    url = 'https://sports4africa.com/testUSSD/cancelBet'
    license_code = '1000'
    point_of_sale_code = '1000'
    terminal_id = '0'
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    ticket_id = params[:ticket_id]
    @error_code = ''
    @error_description = ''
    response_body = ''
    response_code = ''
    @bet = Bet.where("ticket_id = '#{ticket_id}' AND validated IS TRUE")
    body = %Q[<?xml version="1.0" encoding="UTF-8"?>
              <ServicesPSQF>
                <CancelRequest>
                  <CodConc>#{license_code}</CodConc>
		              <CodDiritto>#{point_of_sale_code}</CodDiritto>
		              <IdTerminal>#{terminal_id}</IdTerminal>
		              <TransactionID>#{transaction_id}</TransactionID>
		              <TicketID>#{ticket_id}</TicketID>
	              </CancelRequest>
              </ServicesPSQF>]

    if @bet.blank?
      @error_code = '5000'
      @error_description = 'The ticket ID could not be found.'
    else
      request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

      request.on_complete do |response|
        if response.success?
          response_body = response.body
          nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

          if !nokogiri_response.blank?
            response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
            if response_code == '0' || response_code == '1024'
              if cancel_bet(@bet.first)
                @bet.first.update_attributes(cancelled: true, cancelled_at: DateTime.now)
                @bet_cancellation_result = (nokogiri_response.xpath('//CancelResponse') rescue nil)
              end
            else
              @bet.first.update_attributes(cancelled: false, cancelled_at: DateTime.now)
              @error_code = '4002'
              @error_description = 'Could not cancel the coupon.'
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
    end

    LudwinLog.create(operation: "Annulation de pari", transaction_id: transaction_id, error_code: @error_code, sent_body: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_coupon_payment_notification
    @error_code = ''
    @error_description = ''
    remote_ip_address = request.remote_ip
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    url = 'https://sports4africa.com/testUSSD/paymentTicket'
    payment_notification_envelope = (Nokogiri::XML(request.body.read) rescue nil)
    LudwinLog.create(operation: "Paiement de coupon", response_body: request.body.read, remote_ip_address: remote_ip_address)

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

        if !@bet.pn_ticket_status.blank?
          @error_code = '5002'
          @error_description = 'This coupon have already been validated.'
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
              body = %Q[<?xml version="1.0" encoding="UTF-8"?><ServicesPSQF><PaymentRequest><CodConc>299</CodConc><CodDiritto>595</CodDiritto><IdTerminal>201</IdTerminal><TransactionID>#{transaction_id}</TransactionID><TicketID>#{ticket_id}</TicketID ></PaymentRequest></ServicesPSQF>]
              print body

              request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "text/xml"}, ssl_verifypeer: false, ssl_verifyhost: 0)

              request.on_complete do |response|
                if response.success?
                  response_body = response.body
                  response_body = %Q[<?xml version='1.0' encoding='UTF-8'?>
<ServicesPSQF>
  <PaymentRequest>
    <ReturnCode><Code>0</Code></ReturnCode>
    <Description>OK</Description>
  </PaymentRequest>
</ServicesPSQF>]
                  nokogiri_response = (Nokogiri::XML(response_body) rescue nil)

                  if !nokogiri_response.blank?
                    response_code = (nokogiri_response.xpath('//ReturnCode').at('Code').content rescue nil)
                    if response_code == '0' || response_code == '1024'
                      # Paymoney payment
                      pay_earnings(@bet, "LhSpwtyN", @bet.win_amount)
                      @bet.update_attributes(pr_status: true, payment_status_datetime: DateTime.now, pr_transaction_id: transaction_id)
                      build_message(@bet, @bet.win_amount, "à SPORTCASH", @bet.ticket_id)
                      send_sms_notification(@bet, @msisdn, "SPORTCASH", @message_content)
                    else
                      @bet.update_attributes(pr_status: false, payment_status_datetime: DateTime.now, pr_transaction_id: transaction_id)
                      @error_code = '4002'
                      @error_description = 'The bet could not be processed.'
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

              LudwinLog.create(operation: "Paiement de coupon", response_body: response_body, remote_ip_address: remote_ip_address)
            end
          else
            @error_code = '5003'
            @error_description = 'Invalid notification status.'
          end

          @bet.update_attributes(error_code: @error_code, error_description: @error_description)
        end
      end
    end

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
      @bets = Bet.where(gamer_id: params[:gamer_id])
    end
  end
end
