class AilPmuController < ApplicationController

  def set_credentials
    @user_name = "NGSER"
    @password = "secure1!"
    @terminal_id = "10000"
    @operator_id = "1"
    @operator_pin = "1"
    @audit_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s
    @message_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    @user_id = "1234"
    @confirm_id = (AilPmu.last.transaction_id rescue "")
    @date_time = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
  end

  def api_get_draws
    set_credentials
    remote_ip_address = request.remote_ip
    url = "http://office.rtsapps.co.za:8126/RTS_AVTBet_ws_V1/AVTBetV1.svc/draws/get"
    @error_code = ''
    @error_description = ''
    response_body = ''
    body = %Q[{
	              revision: 1,
	              header: {
		              userName: "#{@user_name}",
		              password: "#{@password}",
		              terminalID: #{@terminal_id},
		              operatorID: #{@operator_id}
		              operatorPIN: #{@operator_pin}
		              auditID: #{@audit_id},
                  messageID: #{@message_id},
                  userID: #{@user_id},
                  dateTime: "#{@date_time}"
                },
                content: {
		              drawState: -1,
		              MaxRows: 10
                }
              }]

    request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post)

    request.on_complete do |response|
      if response.success?
        response_body = response.body
        json_response = (JSON.parse(response_body) rescue nil)

        if !json_response.blank?
          if (json_response["header"]["status"] rescue nil) == 'success'
            @draws_list = (json_response["content"]["rows"] rescue nil)
          else
            @error_code = '4002'
            @error_description = 'Cannot retrieve the list of draws.'
          end
        else
          @error_code = '4001'
          @error_description = 'Error while parsing JSON.'
        end
      else
        @error_code = '4000'
        @error_description = 'Unavailable resource.'
      end
    end

    request.run

    AilPmuLog.create(operation: 'Liste complète des tirages', transaction_id: @message_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_place_bet
    set_credentials
    remote_ip_address = request.remote_ip
    url = "http://office.rtsapps.co.za:8126/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/placebet"
    @error_code = ''
    @error_description = ''
    response_body = ''
    @request_body = request.body.read
    body = %Q[{
	              revision: 1,
	              header: {
		              userName: "#{@user_name}",
		              password: "#{@password}",
		              terminalID: #{@terminal_id},
		              operatorID: #{@operator_id}
		              operatorPIN: #{@operator_pin}
		              auditID: #{@audit_id},
                  messageID: #{@message_id},
                  userID: #{@user_id},
                  dateTime: "#{@date_time}"
                },
                content: {
		              betCode: #{@bet_code},
		              betModifier: #{@bet_modifier},
		              selector1: #{@selector1},
		              selector2: #{@selector2},
		              repeats: #{@repeats},
		              specialEntries:  \[#{@special_entries}\],
		              normalEntries:  \[#{@normal_entries}\]
                }
              }]

    request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post)

    request.on_complete do |response|
      if response.success?
        response_body = response.body
        json_response = (JSON.parse(response_body) rescue nil)

        if !json_response.blank?
          if (json_response["header"]["status"] rescue nil) == 'success'
            @bet = (json_response["content"] rescue nil)
          else
            @error_code = '4002'
            @error_description = 'Cannot place the bet.'
          end
        else
          @error_code = '4001'
          @error_description = 'Error while parsing JSON.'
        end
      else
        @error_code = '4000'
        @error_description = 'Unavailable resource.'
      end
    end

    request.run

    AilPmuLog.create(operation: 'Prise de pari', transaction_id: @message_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def filter_place_bet_incoming_request
    json_request = (JSON.parse(@request_body) rescue nil)

    if json_request.blank?
      @error_code = '5000'
      @error_description = 'Invalid JSON data.'
    else
      @bet_code = json_request["bet_code"]
      @bet_modifier = json_request["bet_modifier"]
      @selector1 = json_request["selector1"]
      @selector2 = json_request["selector2"]
      @repeats = json_request["repeats"]
      @special_entries = json_request["special_entries"]
      @normal_entries = json_request["normal_entries"]
    end
  end
end
