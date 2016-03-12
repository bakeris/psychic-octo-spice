class CmController < ApplicationController
  # 3000- La connexion n'a pas pu être établie
  # 3001- La session n'a pas pu être récupérée
  # 3002- Le programme n'a pas pu être récupéré
  # 3003- La course n'a pas pu être récupérée

  #before_action :only => :guard do |s| s.get_service_by_token(params[:currency], params[:service_token], params[:operation_token], params[:order], params[:transaction_amount], params[:id]) end
  before_action :ensure_login, only: [:api_current_session, :api_get_program, :api_get_race, :api_get_bet, :api_get_results, :api_get_dividends, :api_evaluate_game, :api_sell_ticket, :api_cancel_ticket, :api_get_winners]

  @@user_name = "ngser@lonaci"
  @@password = "lemotdepasse"
  @@notification_url = "http://154.68.45.82:1180/api/dc4741d1b1/"
  @@hub_notification_url = "http://parionsdirect.ci" # URL vers la plateforme de Moïse
  #@@cm3_server_url = "http://office.cm3.work:27000"
  @@cm3_server_url = "http://192.168.1.41:29000"

  def ensure_login
    @connection_id = CmLogin.first.connection_id rescue nil
    if @connection_id.blank?
      body = %Q[<?xml version='1.0' encoding='UTF-8'?>
                <loginRequest>
                  <username>#{@@user_name}</username>
                  <password>#{@@password}</password>
                  <notificationUrl>#{@@notification_url}</notificationUrl>
                </loginRequest>]
      send_request(body, "#{@@cm3_server_url}/login")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)

      if error_code.blank? && @error != true
        @connection_id = (@request_result.xpath('//loginResponse').at('connectionId').content  rescue nil)
        CmLogin.create(connection_id: @connection_id)
        CmLog.create(operation: "Login", connection_id: @connection_id, login_request: body, login_response: @response_body)
      else
        @login_error = true
        CmLogin.first.delete rescue nil
        CmLog.create(login_error_code: error_code, login_error_description: (@request_result.xpath('//return').at('message').content rescue nil), login_request: body, login_response: @response_body, login_error_code: @response_code)
      end
    end
  end

  def api_current_session
    @error_code = ''
    @error_description = ''

    if @login_error
      @error_code = '3000'
      @error_description = "Session interrompue, veuillez réessayer."
      #logout
    else
      send_request("<sessionRequest><connectionId>#{@connection_id}</connectionId></sessionRequest>", "#{@@cm3_server_url}/getCurrentSession")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)
      if error_code.blank? && @error != true
        @session_id = (@request_result.xpath('//session').at('sessionId').content rescue nil)
        @session_date = (@request_result.xpath('//session').at('date').content rescue nil)
        @status = (@request_result.xpath('//session').at('status').content rescue nil)
        @currency_name = (@request_result.xpath('//currency').at('name').content rescue nil)
        @currency_mnemonic = (@request_result.xpath('//currency').at('mnemonic').content rescue nil)
        @program_id = (@request_result.xpath('//programIdList').at('programId').content rescue nil)
      else
        @error_code = '3001'
        @error_description = "La session n'a pas pu être récupérée."

        reset_connection_id(error_code)
      end
    end
    CmLog.create(operation: "Current session", current_session_response: @response_body, connection_id: @connection_id)
  end

  def api_get_program
    @error_code = ''
    @error_description = ''

    if @login_error
      @error_code = '3000'
      @error_description = "Session interrompue, veuillez réessayer."
      #logout
    else
      send_request("<programRequest><connectionId>#{@connection_id}</connectionId><programId>#{params[:program_id]}</programId></programRequest>", "#{@@cm3_server_url}/getProgram")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)
      if error_code.blank? && @error != true
        @race_ids = ""
        @program_id = (@request_result.xpath('//program').at('programId').content rescue nil)
        @type = (@request_result.xpath('//program').at('type').content rescue nil)
        @name = (@request_result.xpath('//program').at('name').content rescue nil)
        @program_date = (@request_result.xpath('//program').at('date').content rescue nil)
        @program_message = (@request_result.xpath('//programData').at('message').content rescue nil)
        @program_number = (@request_result.xpath('//programData').at('number').content rescue nil)
        @status = (@request_result.xpath('//programData').at('status').content rescue nil)
        race_ids = (@request_result.xpath('//raceIdList/raceId') rescue nil)
        unless race_ids.blank?
          race_ids.each do |race_id|
            @race_ids << (race_id.content rescue '') + '-'
          end
        end

        CmLog.create(operation: "Get program", get_program_error_response: @response_body, connection_id: @connection_id)
      else
        @error_code = '3002'
        @error_description = "Le programme n'a pas pu être récupéré."
        CmLog.create(operation: "Get program", get_program_error_code: @response_code, get_program_error_response: @response_body, connection_id: @connection_id)

        reset_connection_id(error_code)
      end
    end
  end

  # Ask for scratched list model
  # Exécuté 1 fois, retourne 404 - Exécuté une autre fois retourne les résultats
  def api_get_race
    @error_code = ''
    @error_description = ''

    if @login_error
      @error_code = '3000'
      @error_description = "Session interrompue, veuillez réessayer."
      #logout
    else
      body = %Q[<?xml version='1.0' encoding='UTF-8'?><raceRequest><connectionId>#{@connection_id}</connectionId><programId>#{params[:program_id]}</programId><raceId>#{params[:race_id]}</raceId></raceRequest>]
      send_request(body, "#{@@cm3_server_url}/getRace")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)
      if error_code.blank? && @error != true
        @bet_ids = ""
        @scrached_list = ""
        @program_id = (@request_result.xpath('//race').at('programId').content rescue nil)
        @race_id = (@request_result.xpath('//race').at('raceId').content rescue nil)
        @name = (@request_result.xpath('//race').at('name').content rescue nil)
        @number = (@request_result.xpath('//race').at('number').content rescue nil)
        @close_time = (@request_result.xpath('//race').at('close_time').content rescue nil)
        @status = (@request_result.xpath('//race').at('status').content rescue nil)
        @max_runners = (@request_result.xpath('//race').at('maxRunners').content rescue nil)

        scratched_list = (@request_result.xpath('//scratchedList/horse') rescue nil)
        unless scratched_list.blank?
          scratched_list.each do |horse|
            @scrached_list << (horse.content rescue '') + '-'
          end
        end

        bet_ids = (@request_result.xpath('//betIdList/betId') rescue nil)
        unless bet_ids.blank?
          bet_ids.each do |bet_id|
            @bet_ids << (bet_id.content rescue '') + '-' + (bet_id["status"] rescue '') + ','
          end
        end

=begin
        bet_ids = (@request_result.xpath('//betIdList/betId[@status="PAYMENT"]') rescue nil)
        unless bet_ids.blank?
          bet_ids.each do |bet_id|
            @bet_ids << (bet_id.content rescue '') + '-'
          end
        end
=end

        CmLog.create(operation: "Get Race", get_race_request_body: body, get_race_response: @response_body, connection_id: @connection_id)
      else
        @error_code = '3003'
        @error_description = "La course n'a pas pu être récupérée."
        CmLog.create(operation: "Get Race", get_race_request_body: body, get_race_response: @response_body, get_race_code: @response_code, connection_id: @connection_id)

        reset_connection_id(error_code)
      end
    end
  end

  def api_get_bet
    @error_code = ''
    @error_description = ''

    if @login_error
      @error_code = '3000'
      @error_description = "Session interrompue, veuillez réessayer."
      #logout
    else
      body = %Q[<?xml version='1.0' encoding='UTF-8'?><betRequest><connectionId>#{@connection_id}</connectionId><betId>#{params[:bet_id]}</betId></betRequest>]
      send_request(body, "#{@@cm3_server_url}/getBet")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)

      if error_code.blank? && @error != true
        @bet_id = (@request_result.xpath('//bet').at('betId').content)
        @name = (@request_result.xpath('//bet').at('name').content rescue nil)
        @mnemonic = (@request_result.xpath('//bet').at('mnemonic').content rescue nil)
        @unit = (@request_result.xpath('//bet').at('unit').content rescue nil)
        @max_nb_units = (@request_result.xpath('//bet').at('maxNbUnits').content rescue nil)
        @full_boxing = (@request_result.xpath('//bet').at('fullBoxing').content rescue nil)
        @full_box_name = (@request_result.xpath('//bet').at('fullBoxName').content rescue nil)
        formulas = (@request_result.xpath('//bet/formula') rescue nil)
        unless formulas.blank?
          @bet_formulas = []
          formulas.each do |formula|
            tmp_formula = {}
            tmp_formula.merge!({:name => (formula.at('name').content rescue '')})
            tmp_formula.merge!({:minimum => (formula.at('minimum').content rescue '')})
            tmp_formula.merge!({:maximum => (formula.at('maximum').content rescue '')})
            tmp_formula.merge!({:max_fields => (formula.at('max_fields').content rescue '')})
            tmp_formula.merge!({:allow_fields => (formula.at('allow_fields').content rescue '')})
            @bet_formulas << tmp_formula
          end
        end

        CmLog.create(operation: "Get bet", get_bet_request_body: body, get_bet_response: @response_body, connection_id: @connection_id)
      else
        @error_code = '3004'
        @error_description = "La liste des paris n'a pas pu être récupérée."
        CmLog.create(operation: "Get bet", get_bet_request_body: body, get_bet_response: @response_body, get_bet_id: @response_code, connection_id: @connection_id)

        reset_connection_id(error_code)
      end
    end
  end

  def api_get_results
    @error_code = ''
    @error_description = ''

    if @login_error
      @error_code = '3000'
      @error_description = "Session interrompue, veuillez réessayer."
      #logout
    else
      body = %Q[<?xml version='1.0' encoding='UTF-8'?><resultRequest><connectionId>#{@connection_id}</connectionId><programId>#{params[:program_id]}</programId><raceId>#{params[:race_id]}</raceId></resultRequest>]
      send_request(body, "#{@@cm3_server_url}/getResult")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)
      if error_code.blank? && @error != true
        @rank_1 =  (@request_result.xpath('//result/rank[@number="1"]').at('horse').content rescue nil)
        @rank_2 =  (@request_result.xpath('//result/rank[@number="2"]').at('horse').content rescue nil)
        @rank_3 =  (@request_result.xpath('//result/rank[@number="3"]').at('horse').content rescue nil)
        @rank_4 =  (@request_result.xpath('//result/rank[@number="4"]').at('horse').content rescue nil)
        @rank_5 =  (@request_result.xpath('//result/rank[@number="5"]').at('horse').content rescue nil)
        @rank_6 =  (@request_result.xpath('//result/rank[@number="6"]').at('horse').content rescue nil)
        @scratched =  (@request_result.xpath('//result/rank[@number="SCRATCHED"]').at('horse').content rescue nil)

        CmLog.create(operation: "Get Results", get_results_request_body: body, get_results_response: @response_body, connection_id: @connection_id)
      else
        @error_code = '3005'
        @error_description = "Les résultats n'ont pas pu être récupérés."
        CmLog.create(operation: "Get Results", get_results_request_body: body, get_results_response: @response_body, get_results_code: @response_code, connection_id: @connection_id)

        reset_connection_id(error_code)
      end
    end
  end

  def api_get_dividends
    @error_code = ''
    @error_description = ''

    if @login_error
      @error_code = '3000'
      @error_description = "Session interrompue, veuillez réessayer."
      #logout
    else
      body = %Q[<?xml version='1.0' encoding='UTF-8'?><dividendsRequest><connectionId>#{@connection_id}</connectionId><programId>#{params[:program_id]}</programId><raceId>#{params[:race_id]}</raceId></dividendsRequest>]
      send_request(body, "#{@@cm3_server_url}/getDividends")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)
      if error_code.blank? && @error != true
        @dividends = []
        dividends = (@request_result.xpath('//dividendsResponse/dividend') rescue nil)
        unless dividends.blank?
          dividends.each do |dividend|
            tmp_dividend = {}
            tmp_dividend.merge!({:bet_id => (dividend.at('betId').content rescue '')})
            tmp_dividend.merge!({:option => (dividend.at('option').content rescue '')})
            tmp_dividend.merge!({:combination => (dividend.at('combination').content rescue '')})
            tmp_dividend.merge!({:win_amount => (dividend.at('value[@type="GAIN"]').content rescue '')})
            tmp_dividend.merge!({:dividend_amount => (dividend.at('value[@type="DIVIDEND"]').content rescue '')})
=begin
            horses = (dividend.xpath('combination/horse') rescue nil)
            horses_array = []
            unless horses.blank?
              horses.each do |horse|
                horses_array << (horse.content rescue '')
              end
            end
            tmp_dividend.merge!({:horses => horses_array})
=end
            @dividends << tmp_dividend
          end
        end

        CmLog.create(operation: "Get dividends", get_dividends_request_body: body, get_dividends_response: @response_body, connection_id: @connection_id)
      else
        @error_code = '3006'
        @error_description = "Les dividendes n'ont pas pu être récupérés."
        CmLog.create(operation: "Get dividends", get_dividends_request_body: body, get_dividends_response: @response_body, get_dividends_code: @response_code, connection_id: @connection_id)

        reset_connection_id(error_code)
      end
    end
  end

  def api_evaluate_game
    @error_code = ''
    @error_description = ''

    if @login_error
      @error_code = '3000'
      @error_description = "Session interrompue, veuillez réessayer."
      #logout
    else
      @games = JSON.parse(request.body.read)["games"] rescue ""
      if @games.blank?
        @error_code = '2000'
        @error_description = "Le corps de la requête n'est pas valide."
      else
        format_eval_games
        body = %Q[<?xml version='1.0' encoding='UTF-8'?><evaluationRequest><connectionId>#{@connection_id}</connectionId><programId>#{params[:program_id]}</programId><raceId>#{params[:race_id]}</raceId>#{@games_body}</evaluationRequest>]

        send_request(body, "#{@@cm3_server_url}/evaluateGames")

        error_code = (@request_result.xpath('//return').at('error').content rescue nil)

        if error_code.blank? && @error != true
          scratched = (@request_result.xpath('//scratchedList/horse') rescue nil)
          @scratched_array = []
          unless scratched.blank?
            scratched.each do |scratch|
              @scratched_array << (scratch.content rescue '')
            end
          end
          @evaluations_array = []
          evaluations = (@request_result.xpath('//evaluationResponse/evaluation') rescue nil)
          unless evaluations.blank?
            evaluations.each do |evaluation|
              tmp_evaluation = {}
              tmp_evaluation.merge!({:game_id => (evaluation["index"] rescue '')})
              tmp_evaluation.merge!({:amount => (evaluation.at('amount').content rescue '')})
              tmp_evaluation.merge!({:nb_combinations => (evaluation.at('nbCombinations').content rescue '')})
              tmp_evaluation.merge!({:error => (evaluation.at('error').content rescue '')})
              tmp_evaluation.merge!({:message => (evaluation.at('message').content rescue '')})
              tmp_evaluation.merge!({:position => (evaluation.at('position').content rescue '')})
              @evaluations_array << tmp_evaluation
            end
          end

          CmLog.create(operation: "Evaluate game", get_eval_request: body, get_eval_response: @response_body, connection_id: @connection_id)
        else
          @error_code = '3007'
          @error_description = "Aucun pari selectionné."
          CmLog.create(operation: "Evaluate game", get_eval_request: body, get_eval_response: @response_body, get_eval_code: @response_code, connection_id: @connection_id)

          reset_connection_id(error_code)
        end
      end
    end
  end

  def format_eval_games
    @games_body = ""
    @games.each do |game|
      @games_body << %Q[<game index="#{game["game_id"]}">]
      @games_body << %Q[<betId>#{game["bet_id"]}</betId>]
      @games_body << %Q[<nbUnits>#{game["nb_units"]}</nbUnits>]
      @games_body << %Q[<fullBox>#{game["full_box"]}</fullBox>]
      @games_body << "<selection>"
      unless game["items"].blank?
        game["items"].each do |item|
          @games_body << "<item>#{item}</item>"
        end
      end
      @games_body << "</selection>"
      @games_body << "</game>"
    end
  end

  def api_sell_ticket
    request_body = request.body.read
    @error_code = ''
    @error_description = ''
    @gamer_id = params[:gamer_id]
    @remote_ip = request.remote_ip
    paymoney_account_number = params[:paymoney_account_number]
    password = params[:password]
    @begin_date = params[:begin_date]
    @end_date = params[:end_date]
    @transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]

    if @login_error
      @error_code = '3000'
      @error_description = "Session interrompue, veuillez réessayer."
      #logout
    else
      if gamer_account_exists
        @bet = JSON.parse(request_body) rescue ""



        if valid_bet_params
          set_scratched_list
          set_wagers

          body = %Q[<?xml version='1.0' encoding='UTF-8'?><sellRequest><connectionId>#{@connection_id}</connectionId><sale><programId>#{@program_id}</programId><raceId>#{@race_id}</raceId><transactionId>#{@transaction_id}</transactionId><amount>#{@amount}</amount>#{@scratched_body}#{@wagers_body}</sale></sellRequest>]

          create_bet

          send_request(body, "#{@@cm3_server_url}/sellTicket")

          error_code = (@request_result.xpath('//return').at('error').content rescue nil)
          error_message = (@request_result.xpath('//return').at('message').content rescue nil)

          if error_code.blank? && @error != true
            @serial_number = (@request_result.xpath('//ticket').at('serialNumber').content)
            @amount = (@request_result.xpath('//ticket').at('amount').content rescue nil)
            @bet.update_attributes(serial_number: @serial_number, placement_request: body, placement_response: @response_body, paymoney_account_number: paymoney_account_number, bet_identifier: "#{DateTime.now.to_i}-#{@program_id}-#{@race_id}", bet_status: "En cours")

            place_cm3_bet_with_cancellation(@bet, "McoaDIET", paymoney_account_number, password, @amount)

          else
            @error_code = error_code
            @error_description = error_message
            CmLog.create(operation: "Prise de pari", sell_ticket_request: body, sell_ticket_response: @response_body, sell_ticket_code: error_code, connection_id: @connection_id)

            reset_connection_id(error_code)
          end
        else
          @error_code = '3008'
          @error_description = "Les paramètres du pari ne sont pas valides."
          CmLog.create(operation: "Prise de pari", sell_ticket_request: body, sell_ticket_response: @error_description, sell_ticket_code: @error_code, connection_id: @connection_id)
        end
      else
        @error_code = '3009'
        @error_description = "Le compte parieur n'a pas été trouvé."
        CmLog.create(operation: "Prise de pari", sell_ticket_request: body, sell_ticket_response: @error_description, sell_ticket_code: @error_code, connection_id: @connection_id)
      end
    end
  end

  def create_bet
    @bet = Cm.create(connection_id: @connection_id, program_id: @program_id, race_id: @race_id, sale_client_id: @transaction_id, punter_id: @gamer_id, game_account_token: @gamer_id, amount: @amount, scratched_list: (@scratched_list.join('-') rescue nil), remote_ip: @remote_ip, begin_date: @begin_date, end_date: @end_date, bet_placed_at: DateTime.now)
    @wagers.each do |wager|
      unless wager.blank?
        @bet.cm_wagers.create(bet_id: (wager["bet_id"] rescue nil), nb_units: (wager["nb_units"] rescue nil), nb_combinations: (wager["nb_combinations"] rescue nil), full_box: (wager["full_box"] rescue nil), selections_string: (wager["selection"].join("-") rescue nil))
      end
    end
  end

  def gamer_account_exists
    status = true

    @user = User.find_by_uuid(@gamer_id)
    if @user.blank?
      status = false
    end

    return status
  end

  def valid_bet_params
    valid = true
    @program_id = @bet["program_id"] rescue ""
    @race_id = @bet["race_id"] rescue ""
    @amount = @bet["amount"] rescue ""
    @scratched_list = @bet["scratched_list"] rescue []
    @wagers = @bet["wagers"] rescue []

    if @program_id.blank? || @race_id.blank? || @amount.blank? || @wagers.blank? || (@scratched_list.class.to_s != "Array") || (@wagers.class.to_s != "Array")
      valid = false
    end

    return valid
  end

  def set_scratched_list
    @scratched_body = "<scratchedList>"
    @scratched_list.each do |scratched|
      @scratched_body << "<horse>#{scratched}</horse>"
    end
    @scratched_body << "</scratchedList>"
  end

  def set_wagers
    @wagers_body = ""
    @wagers.each do |wager|
      #wager = JSON.parse(wager) rescue nil
      puts "wager---------------------------" + wager.to_s
      unless wager.blank?
        @wagers_body << "<wager>"
        @wagers_body << "<betId>#{wager["bet_id"]}</betId>"
        @wagers_body << "<nbUnits>#{wager["nb_units"]}</nbUnits>"
        @wagers_body << "<nbCombinations>#{wager["nb_combinations"]}</nbCombinations>"
        @wagers_body << "<fullBox>#{wager["full_box"]}</fullBox>"
        if (wager["selection"].class.to_s rescue nil) == "Array"
          @wagers_body << "<selection>"
          wager["selection"].each do |item|
            @wagers_body << "<item>#{item}</item>"
          end
          @wagers_body << "</selection>"
        end
        @wagers_body << "</wager>"
      end
    end
  end

  def api_cancel_ticket
    @error_code = ''
    @error_description = ''
    @serial_number = params[:serial_number]

    if @login_error
      @error_code = '3000'
      @error_description = "Session interrompue, veuillez réessayer."
      #logout
    else
      if serial_exists
        if bet_cancellable
          body = %Q[<?xml version='1.0' encoding='UTF-8'?><cancelRequest><connectionId>#{@connection_id}</connectionId><serialNumber>#{@serial_number}</serialNumber></cancelRequest>]

          send_request(body, "#{@@cm3_server_url}/cancelTicket")

          error_code = (@request_result.xpath('//return').at('error').content rescue nil)
          error_message = (@request_result.xpath('//return').at('message').content rescue nil)

          if error_code.blank? && @error != true
            cancel_cm3_bet(@bet)
          else
            @error_code = error_code
            @error_description = error_message
            @bet.update_attributes(cancel_request: body, cancel_response: @response_body, cancelled: false, cancelled_at: DateTime.now, bet_status: "Annulé")

            reset_connection_id(error_code)
          end
        else
          @error_code = '3011'
          @error_description = "Ce ticket n'est pas annulable."
        end
      else
        @error_code = '3010'
        @error_description = "Le numéro de série du ticket n'a pas été trouvé."
      end
    end
  end

  def serial_exists
    status = true

    @bet = Cm.find_by_serial_number(@serial_number)

    if @bet.blank?
      status = false
    end

    return status
  end

  def bet_cancellable
    status = false

    if !@bet.p_payment_transaction_id.blank? && (@bet.cancelled == nil) && @bet.p_validated != true
      status = true
    end

    return status
  end

  def api_get_winners
    @error_code = ''
    @error_description = ''
    @connection_id = CmLogin.first.connection_id rescue nil
    #race_id = @race_id]
    #program_id = @program_id]

    if @login_error
      @error_code = '3000'
      @error_description = "Session interrompue, veuillez réessayer."
      ensure_login
      #logout
    else
      body = %Q[<?xml version='1.0' encoding='UTF-8'?><winningsRequest><connectionId>#{@connection_id}</connectionId><programId>#{@program_id}</programId><raceId>#{@race_id}</raceId></winningsRequest>]

      send_request(body, "#{@@cm3_server_url}/getWinnings")

      CmLog.create(operation: "Get winners", connection_id: @connection_id, login_request: body, login_response: @response_body)

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)
      error_message = (@request_result.xpath('//return').at('message').content rescue nil)

      if error_code.blank? && @error != true
        update_winners_list
      else
        @error_code = error_code
        @error_description = error_message
        reset_connection_id(error_code)
        #logout
      end
    end
  end

  def update_winners_list
    unless @request_result.blank?
      winnings = (@request_result.xpath('//winnings/winning') rescue nil)
      unless winnings.blank?
        @sill_amount = Parameters.first.sill_amount rescue 0
        winnings.each do |winning|

          bet = Cm.where("sale_client_id = '#{winning.at('transactionId').content}' AND serial_number = '#{winning.at('serialNumber').content}' AND p_validated IS NULL").first rescue nil
          unless bet.blank?
            bet.update_attributes(win_reason: winning.at('reason').content, win_amount: winning.at('amount').content, bet_status: "Gagnant")
            bet_id = winning.at('betId').content rescue nil

            #unless bet_ids.blank?
              #bet_ids.each do |bet_id|
                bet.cm_wagers.where("bet_id = '#{bet_id}'").first.update_attributes(winner: true) rescue nil
                if (winning.at('amount').content.to_f rescue 0) > @sill_amount
                  bet.update_attributes(bet_status: "Vainqueur en attente de paiement")
                else
                  validate_bet_cm3("McoaDIET", bet.win_amount, bet.race_id)
                end

                # SMS notification
                build_message(bet, bet.win_amount, "au PMU-ALR", bet.serial_number)
                send_sms_notification(bet, @msisdn, "PMU-ALR", @message_content)

                # Email notification
                WinningNotification.notification_email(@user, bet.win_amount, "au PMU-ALR", "PMU-ALR", bet.serial_number, bet.paymoney_account_number, '').deliver
                #if validate_bet_cm3(game_account_token, transaction_amount, race_id)

                #end
              #end
            #end
          end
        end
      end
    end
  end

  def api_notify_session
    request_body = request.body.read
    notification = (Nokogiri::XML(request_body) rescue nil)
    status = nil

    if !notification.blank?
      @connection_id =  (notification.xpath('//sessionNotification').at('connectionId').content rescue nil)
      @session_id =  (notification.xpath('//sessionNotification').at('sessionId').content rescue nil)
      @reason =  (notification.xpath('//sessionNotification').at('reason').content rescue nil)

      if valid_notify_session_parameters?
        if @reason.downcase != "balance" && (@reason.downcase == "new" || @reason.downcase == "program_added")
          RestClient.get "#{@@hub_notification_url}/api/cm3/session_notification/#{@session_id}/#{@reason.upcase}" rescue nil
          CmLog.create(operation: "Session notification", notify_session_request_body: "#{@@hub_notification_url}/api/cm3/session_notification/#{@session_id}/#{@reason}")
          status = "200"
        else
          status = "412"
        end
      else
        status = "412"
      end
    else
     status = "422"
    end

    CmLog.create(operation: "Notify session", session_notification_connection_id: @connection_id, session_notification_session_id: @session_id, session_notification_reason: @reason, notify_session_request_body: request_body)

    render nothing: true, status: 200 #render text: status
  end

  def valid_notify_session_parameters?
    status = true
    if @connection_id.blank? || @session_id.blank? || @reason.blank?
      status = false
    end

    return status
  end

  def api_notify_program
    request_body = request.body.read
    notification = (Nokogiri::XML(request_body) rescue nil)
    status = nil

    if !notification.blank?
      @connection_id =  (notification.xpath('//programNotification').at('connectionId').content rescue nil)
      @program_id =  (notification.xpath('//programNotification').at('programId').content rescue nil)
      @reason =  (notification.xpath('//programNotification').at('reason').content rescue nil)

      if valid_notify_program_parameters?
        if @reason.downcase == "state"
          RestClient.get "#{@@hub_notification_url}/api/cm3/program_notification/#{@program_id}/#{@reason.upcase}" rescue nil
          CmLog.create(operation: "Program notification", notify_session_request_body: "#{@@hub_notification_url}/api/cm3/program_notification/#{@program_id}/#{@reason}")
          status = "200"
        else
          status = "412"
        end
      else
        status = "412"
      end
    else
     status = "422"
    end

    CmLog.create(operation: "Notify session", session_program_connection_id: @connection_id, program_notification_program_id: @program_id, session_notification_reason: @reason, notify_session_request_body: request_body)

    render nothing: true, status: 200 #render text: status
  end

  def valid_notify_program_parameters?
    status = true
    if @connection_id.blank? || @program_id.blank? || @reason.blank?
      status = false
    end

    return status
  end

  def api_notify_race

    request_body = request.body.read
    notification = (Nokogiri::XML(request_body) rescue nil)
    status = nil

    if !notification.blank?
      @connection_id =  (notification.xpath('//raceNotification').at('connectionId').content rescue nil)
      @program_id =  (notification.xpath('//raceNotification').at('programId').content rescue nil)
      @race_id =  (notification.xpath('//raceNotification').at('raceId').content rescue nil)
      @reason =  (notification.xpath('//raceNotification').at('reason').content.downcase rescue nil)

      if valid_notify_race_parameters?
        if @reason == "max_runners" || @reason == "scratched" || @reason == "couple" || @reason == "state" || @reason == "bet_state" || @reason == "dividends"
          RestClient.get "#{@@hub_notification_url}/api/cm3/race_notification/#{@program_id}/#{@race_id}/#{@reason.upcase}" rescue nil
          CmLog.create(operation: "Race notification", notify_session_request_body: "#{@@hub_notification_url}/api/cm3/race_notification/#{@program_id}/#{@race_id}/#{@reason}")
          status = "200"
        else
          if @reason == "winnings"
            api_get_winners
            status = "200"
            CmLog.create(operation: @reason, notify_session_request_body: 1)
          else
            status = "412"
            CmLog.create(operation: @reason, notify_session_request_body: 2)
          end
        end
      else
        status = "412"
      end
    else
     status = "422"
    end

    CmLog.create(operation: "Notify race", notify_race_connection_id: @connection_id, notify_race_program_id: @program_id, notify_race_race_id: @race_id, notify_race_reason: @reason, notify_race_request_body: request_body)

    #render text: status
    render nothing: true, status: 200
  end

  def valid_notify_race_parameters?
    status = true
    if @connection_id.blank? || @program_id.blank? || @race_id.blank? || @reason.blank?
      status = false
    end

    return status
  end

  def api_gamer_bets
    @error_code = ''
    @error_description = ''

    user = User.find_by_uuid(params[:gamer_id])

    if user.blank?
      @error_code = '4000'
      @error_description = "Ce parieur n'a pas été trouvé."
    else
      @bets = Cm.where(punter_id: params[:gamer_id]).order("created_at DESC")
    end
  end


  def send_request(body, url)
    @request_result = nil
    @response_code = nil
    print "sending request\n"

    request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :get, headers: {'Content-Type'=> "text/xml"})

    request.on_complete do |response|
      if response.success?
        @response_body = response.body
        @request_result = (Nokogiri::XML(@response_body) rescue nil)

        error_code = (@request_result.xpath('//return').at('error').content rescue nil)
        reset_connection_id(error_code)
      else
        @error = true
        @response_code = response.code rescue nil
      end
    end

    request.run
  end

  def reset_connection_id(error_code)
    if error_code == "501"
      logout
      @error_code = '3000'
      @error_description = "Session interrompue, veuillez réessayer."
    end
  end

  def logout
    @connection_id = CmLogin.first.connection_id rescue nil
    body = %Q[<?xml version='1.0' encoding='UTF-8'?>
              <logoutRequest>
                <connectionId>#{@connection_id}</connectionId>
              </logoutRequest>]
    send_request(body, "#{@@cm3_server_url}/logout")
    CmLogin.first.delete rescue nil
    CmLog.create(operation: "Logout", connection_id: @connection_id, login_request: body, login_response: @response_body)
  end

end
