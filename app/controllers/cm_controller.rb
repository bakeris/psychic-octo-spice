class CmController < ApplicationController
  # 3000- La connexion n'a pas pu être établie
  # 3001- La session n'a pas pu être récupérée
  # 3002- Le programme n'a pas pu être récupéré
  # 3003- La course n'a pas pu être récupérée

  #before_action :only => :guard do |s| s.get_service_by_token(params[:currency], params[:service_token], params[:operation_token], params[:order], params[:transaction_amount], params[:id]) end
  before_action :ensure_login, except: [:ensure_login, :send_request]

  @@user_name = "ngser@lonaci"
  @@password = "lemotdepasse"
  @@notification_url = "https://142.11.15.18:11111"

  def ensure_login
    print "before\n"
    if session[:connection_id].blank?
      print "connection id blank\n"
      status = false
      body = %Q[<?xml version='1.0' encoding='UTF-8'?>
                <loginRequest>
                  <username>#{@@user_name}</username>
                  <password>#{@@password}<password>
                  <notificationUrl>#{@@notification_url}</notificationUrl>
                </loginRequest>]
      send_request(body, "http://office.cm3.work:27000/login")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)

      if error_code.blank?
        session[:connection_id] = (@request_result.xpath('//loginResponse').at('connectionId').content)
        CmLog.create(operation: "Login", connection_id: session[:connection_id], login_request: body, login_response: @response_body)
      else
        @login_error = true
        CmLog.create(login_error_code: error_code, login_error_description: (@request_result.xpath('//return').at('message').content rescue nil), login_request: body, login_response: @response_body, login_error_code: @response_code)
      end
    end
  end

  def api_current_session
    @error_code = ''
    @error_description = ''

    if @login_error
      @error_code = '3000'
      @error_description = "La connexion n'a pas pu être établie."
    else
      send_request("", "http://office.cm3.work:27000/getCurrentSession")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)
      if error_code.blank? && @error != true
        @session_id = (@request_result.xpath('//session').at('sessionId').content rescue nil)
        @session_date = (@request_result.xpath('//session').at('date').content rescue nil)
        @status = (@request_result.xpath('//session').at('status').content rescue nil)
        @currency_name = (@request_result.xpath('//currency').at('name').content rescue nil)
        @currency_mnemonic = (@request_result.xpath('//currency').at('mnemonic').content rescue nil)
        @program_id = (@request_result.xpath('//programIdList').at('programId').content rescue nil)

        CmLog.create(operation: "Current session", current_session_response: @response_body, connection_id: session[:connection_id])
      else
        @error_code = '3001'
        @error_description = "La session n'a pas pu être récupérée."
        CmLog.create(operation: "Current session", current_session_error_code: @response_code, current_session_response: @response_body, connection_id: session[:connection_id])
      end
    end
  end

  def api_get_program
    @error_code = ''
    @error_description = ''

    if @login_error
      @error_code = '3000'
      @error_description = "La connexion n'a pas pu être établie."
    else
      send_request("", "http://office.cm3.work:27000/getProgram")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)
      if error_code.blank? && @error != true
        @race_ids = ""
        @program_id = (@request_result.xpath('//program').at('programId').content rescue nil)
        @type = (@request_result.xpath('//program').at('type').content rescue nil)
        @name = (@request_result.xpath('//program').at('name').content rescue nil)
        @program_date = (@request_result.xpath('//program').at('date').content rescue nil)
        @program_message = (@request_result.xpath('//programData').at('message').content rescue nil)
        @program_number = (@request_result.xpath('//programData').at('number').content rescue nil)
        race_ids = (@request_result.xpath('//raceIdList/raceId') rescue nil)
        unless race_ids.blank?
          race_ids.each do |race_id|
            @race_ids << (race_id.content rescue '') + '-'
          end
        end

        CmLog.create(operation: "Get program", get_program_error_response: @response_body, connection_id: session[:connection_id])
      else
        @error_code = '3002'
        @error_description = "Le programme n'a pas pu être récupéré."
        CmLog.create(operation: "Get program", get_program_error_code: @response_code, get_program_error_response: @response_body, connection_id: session[:connection_id])
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
      @error_description = "La connexion n'a pas pu être établie."
    else
      body = %Q[<?xml version='1.0' encoding='UTF-8'?><raceRequest><connectionId>#{session[:connection_id]}</connectionId><programId>#{params[:program_id]}</programId><raceId>#{params[:race_id]}</raceId></raceRequest>]
      send_request(body, "http://office.cm3.work:27000/getRace")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)
      if error_code.blank? && @error != true
        @bet_ids = ""
        @program_id = (@request_result.xpath('//race').at('programId').content rescue nil)
        @race_id = (@request_result.xpath('//race').at('raceId').content rescue nil)
        @name = (@request_result.xpath('//race').at('name').content rescue nil)
        @number = (@request_result.xpath('//race').at('number').content rescue nil)
        @close_time = (@request_result.xpath('//race').at('close_time').content rescue nil)
        @status = (@request_result.xpath('//race').at('status').content rescue nil)
        @max_runners = (@request_result.xpath('//race').at('maxRunners').content rescue nil)
        bet_ids = (@request_result.xpath('//betIdList/betId[@status="PAYMENT"]') rescue nil)
        unless bet_ids.blank?
          bet_ids.each do |bet_id|
            @bet_ids << (bet_id.content rescue '') + '-'
          end
        end

        CmLog.create(operation: "Get Race", get_race_request_body: body, get_race_response: @response_body, connection_id: session[:connection_id])
      else
        @error_code = '3003'
        @error_description = "La course n'a pas pu être récupérée."
        CmLog.create(operation: "Get Race", get_race_request_body: body, get_race_response: @response_body, get_race_code: @response_code, connection_id: session[:connection_id])
      end
    end
  end

  def api_get_bet
    @error_code = ''
    @error_description = ''

    if @login_error
      @error_code = '3000'
      @error_description = "La connexion n'a pas pu être établie."
    else
      body = %Q[<?xml version='1.0' encoding='UTF-8'?><betRequest><connectionId>#{session[:connection_id]}</connectionId><betId>#{params[:bet_id]}</betId></betRequest>]
      send_request(body, "http://office.cm3.work:27000/getBet")

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

        CmLog.create(operation: "Get bet", get_bet_request_body: body, get_bet_response: @response_body, connection_id: session[:connection_id])
      else
        @error_code = '3004'
        @error_description = "La liste des paris n'a pas pu être récupérée."
        CmLog.create(operation: "Get bet", get_bet_request_body: body, get_bet_response: @response_body, get_bet_id: @response_code, connection_id: session[:connection_id])
      end
    end
  end

  def api_get_results
    @error_code = ''
    @error_description = ''

    if @login_error
      @error_code = '3000'
      @error_description = "La connexion n'a pas pu être établie."
    else
      body = %Q[<?xml version='1.0' encoding='UTF-8'?><resultResponse><connectionId>#{session[:connection_id]}</connectionId><programId>#{params[:program_id]}</programId><raceId>#{params[:race_id]}</raceId></resultResponse>]
      send_request(body, "http://office.cm3.work:27000/getResult")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)
      if error_code.blank? && @error != true
        @rank_1 =  (@request_result.xpath('//result/rank[@number="1"]').at('horse').content rescue nil)
        @rank_2 =  (@request_result.xpath('//result/rank[@number="2"]').at('horse').content rescue nil)
        @rank_3 =  (@request_result.xpath('//result/rank[@number="3"]').at('horse').content rescue nil)
        @rank_4 =  (@request_result.xpath('//result/rank[@number="4"]').at('horse').content rescue nil)
        @rank_5 =  (@request_result.xpath('//result/rank[@number="5"]').at('horse').content rescue nil)
        @rank_6 =  (@request_result.xpath('//result/rank[@number="6"]').at('horse').content rescue nil)
        @scratched =  (@request_result.xpath('//result/rank[@number="SCRATCHED"]').at('horse').content rescue nil)

        CmLog.create(operation: "Get Results", get_results_request_body: body, get_results_response: @response_body, connection_id: session[:connection_id])
      else
        @error_code = '3005'
        @error_description = "Les résultats n'ont pas pu être récupérés."
        CmLog.create(operation: "Get Race", get_results_request_body: body, get_results_response: @response_body, get_results_code: @response_code, connection_id: session[:connection_id])
      end
    end
  end

  def api_get_dividends
    @error_code = ''
    @error_description = ''

    if @login_error
      @error_code = '3000'
      @error_description = "La connexion n'a pas pu être établie."
    else
      body = %Q[<?xml version='1.0' encoding='UTF-8'?><dividendsRequest><connectionId>#{session[:connection_id]}</connectionId><programId>#{params[:program_id]}</programId><raceId>#{params[:race_id]}</raceId></dividendsRequest>]
      send_request(body, "http://office.cm3.work:27000/getResult")

      error_code = (@request_result.xpath('//return').at('error').content rescue nil)
      if error_code.blank? && @error != true
        @dividends = []
        dividends = (@request_result.xpath('//dividendsResponse/dividend') rescue nil)
        unless dividends.blank?
          dividends.each do |dividend|
            tmp_dividend = {}
            tmp_dividend.merge!({:bet_id => (dividend.at('betId').content rescue '')})
            tmp_dividend.merge!({:option => (dividend.at('option').content rescue '')})
            tmp_dividend.merge!({:win_amount => (dividend.at('value[@type="GAIN"]').content rescue '')})
            horses = (dividend.xpath('//combination/horse') rescue nil)
            unless horses.blank?
              horses.each do |horse|

              end
            end
            @dividends << tmp_dividend
          end
        end

        @rank_1 =  (@request_result.xpath('//result/rank[@number="1"]').at('horse').content rescue nil)
        @rank_2 =  (@request_result.xpath('//result/rank[@number="2"]').at('horse').content rescue nil)
        @rank_3 =  (@request_result.xpath('//result/rank[@number="3"]').at('horse').content rescue nil)
        @rank_4 =  (@request_result.xpath('//result/rank[@number="4"]').at('horse').content rescue nil)
        @rank_5 =  (@request_result.xpath('//result/rank[@number="5"]').at('horse').content rescue nil)
        @rank_6 =  (@request_result.xpath('//result/rank[@number="6"]').at('horse').content rescue nil)
        @scratched =  (@request_result.xpath('//result/rank[@number="SCRATCHED"]').at('horse').content rescue nil)

        CmLog.create(operation: "Get dividends", get_dividends_request_body: body, get_dividends_response: @response_body, connection_id: session[:connection_id])
      else
        @error_code = '3006'
        @error_description = "Les dividendes n'ont pas pu être récupérés."
        CmLog.create(operation: "Get dividends", get_dividends_request_body: body, get_dividends_response: @response_body, get_dividends_code: @response_code, connection_id: session[:connection_id])
      end
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
      else
        @error = true
        @response_code = response.code rescue nil
      end
    end

    request.run
  end

end
