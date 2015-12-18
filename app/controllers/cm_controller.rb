class CmController < ApplicationController
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

      if error_code == "0" || error_code.blank?
        print "OK\n"
        session[:connection_id] = (@request_result.xpath('//loginResponse').at('connectionId').content)
        CmLog.create(operation: "Login", connection_id: session[:connection_id], login_request: body, login_response: @response_body)
      else
        print "NOK\n"
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
      if error_code == "0" || error_code.blank?
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
      if error_code == "0" || error_code.blank?
        @program_id = (@request_result.xpath('//program').at('programId').content rescue nil)
        @type = (@request_result.xpath('//program').at('type').content rescue nil)
        @name = (@request_result.xpath('//program').at('name').content rescue nil)
        @program_date = (@request_result.xpath('//program').at('date').content rescue nil)
        @program_message = (@request_result.xpath('//programData').at('message').content rescue nil)
        @program_number = (@request_result.xpath('//programData').at('number').content rescue nil)
        @program_race_ids = (@request_result.xpath('//raceIdList/raceId') rescue nil)

        CmLog.create(operation: "Get program", get_program_error_response: @response_body, connection_id: session[:connection_id])
      else
        @error_code = '3002'
        @error_description = "Le programme n'a pas pu être récupéré."
        CmLog.create(operation: "Get program", get_program_error_code: @response_code, get_program_error_response: @response_body, connection_id: session[:connection_id])
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
        print "response success\n"
      else
        @response_code = response.code rescue nil
        print "response error\n"
      end
    end

    request.run
  end

end
