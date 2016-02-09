class AilLotoController < ApplicationController
  def set_credentials
    @user_name = "lotto@test.co.za"
    @password = "helloworld"
    @terminal_id = "100001"
    @operator_id = "1"
    @operator_pin = "1"
    @audit_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..8]
    @message_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..7]
    @transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s
    @user_id = "1"
    @confirm_id = (AilLoto.last.transaction_id rescue "")
    @date_time = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
  end

  def set_minimal_credentials
    @audit_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..8]
    @message_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..7]
  end

  def api_get_draws
    set_credentials
    remote_ip_address = request.remote_ip
    #url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/draws/get"
    url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/draws/get"

    @error_code = ''
    @error_description = ''
    response_body = ''
    body = %Q[{
                "DrawReq":{
                  "revision":"1",
                  "header":{
                    "userName":"#{@user_name}",
                    "password":"#{@password}",
                    "terminalID":#{@terminal_id},
                    "operatorID":#{@operator_id},
                    "operatorPIN":#{@operator_pin},
                    "auditID":#{@audit_id},
                    "messageID":#{@message_id},
                    "userID":1,
                    "dateTime":"#{@date_time}"
                  },
                  "content":{
                    "drawState":-1,
                    "MaxRows":10
                  }
                }
              }]

    request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/json"})

    request.on_complete do |response|
      if response.success?
        response_body = response.body
        json_response = (JSON.parse(response_body) rescue nil)

        if !json_response.blank?
          @error_code = (json_response["content"]["errorCode"] rescue nil)
          if @error_code == 0 && (json_response["header"]["status"] == 'success' rescue nil)
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

    AilLotoLog.create(operation: 'Liste complète des tirages', transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_query_bet
    set_credentials
    remote_ip_address = request.remote_ip
    url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/querybet"
    @error_code = ''
    @error_description = ''
    response_body = ''
    @request_body = request.body.read
    filter_place_bet_incoming_request
    body = %Q|{
                "Bet":{
                  "revision":"1",
                  "header":{
                    "userName":"#{@user_name}",
                    "password":"#{@password}",
                    "terminalID":#{@terminal_id},
                    "operatorID":#{@operator_id},
                    "operatorPIN":#{@operator_pin},
                    "auditID":#{@audit_id},
                    "messageID":#{@message_id},
                    "userID":1,
                    "dateTime":"#{@date_time}"
                  },
                  "content":{
                    "betCode":#{@bet_code},
                    "betModifier":#{@bet_modifier},
                    "selector1":#{@selector1},
                    "selector2":#{@selector2},
                    "repeats":#{@repeats},
                    "specialEntries":\[#{@special_entries}\],
                    "normalEntries":\[#{@normal_entries}\]
                  }
                }
              }|

    request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/json"})

    request.on_complete do |response|
      if response.success?
        response_body = response.body
        json_response = (JSON.parse(response_body) rescue nil)

        if !json_response.blank?
          @error_code = (json_response["content"]["errorCode"] rescue nil)
          @error_description = (json_response["content"]["errorMessage"] rescue nil)

          if @error_code == 0 && (json_response["header"]["status"] == 'success' rescue nil)
            @bet = (json_response["content"] rescue nil)

            unless @bet.blank?
              ticket_number = (json_response["content"]["ticketNumber"] rescue nil)
              ref_number = (json_response["content"]["refNumber"] rescue nil)
              bet_cost_amount = (json_response["content"]["betCostAmount"] rescue nil)
              bet_payout_amount = (json_response["content"]["betPayoutAmount"] rescue nil)

              #ail_pmu = AilPmu.create(transaction_id: @transaction_id, message_id: @message_id, audit_number: @audit_id, date_time: @date_time, bet_code: @bet_code, bet_modifier: @bet_modifier, selector1: @selector1, selector2: @selector2, repeats: @repeats, normal_entries: @normal_entries, special_entries: @special_entries, ticket_number: ticket_number, ref_number: ref_number, bet_cost_amount: bet_cost_amount, bet_payout_amount: bet_payout_amount)
              # Bet acknowledgement
              set_minimal_credentials
              body = %Q|{
                        "Ack":{
                          "revision":"1",
                          "header":{
                            "userName":"#{@user_name}",
                            "password":"#{@password}",
                            "terminalID":#{@terminal_id},
                            "operatorID":#{@operator_id},
                            "operatorPIN":#{@operator_pin},
                            "auditID":#{@audit_id},
                            "messageID":#{@message_id},
                            "userID":1,
                            "dateTime":"#{@date_time}"
                          },
                          "content":{
                            "ticketNumber":"#{ticket_number}",
                            "refNumber":"#{ref_number}",
                            "reqType":0
                          }
                        }
                      }|
              url = "http://dev.rtsapps.co.za:8126/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/ackbet"
              request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/json"})

              request.on_complete do |response|
                if response.success?
                  response_body = response.body
                  json_response = (JSON.parse(response_body) rescue nil)
                  if !json_response.blank?
                    @error_code = (json_response["content"]["errorCode"] rescue nil)
                    @error_description = (json_response["content"]["errorMessage"] rescue nil)

                    if @error_code == 0 && (json_response["header"]["status"] == 'success' rescue nil)
                      #@bet.update_attributes(placement_acknowledge: true, placement_acknowledge_date_time: DateTime.now.to_s)
                    else
                      @error_code = '4005'
                      @error_description = 'Could not acknowledge the query.'
                    end
                  else
                    @error_code = '4004'
                    @error_description = 'Error while parsing JSON query acknowlegement response.'
                  end
                else
                  @error_code = '4003'
                  @error_description = 'Could not acknowledge the query.'
                end
              end

              request.run
              # Bet acknowledgement
            end
          else
            @error_code = '4002'
            @error_description = 'Cannot query the bet.'
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

    AilLotoLog.create(operation: 'Consultation de pari', transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_place_bet
    set_credentials
    remote_ip_address = request.remote_ip
    url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/placebet"
    @error_code = ''
    @error_description = ''
    response_body = ''
    @request_body = request.body.read
    paymoney_account_number = params[:paymoney_account_number]
    password = params[:password]
    gamer_id = params[:gamer_id]
    user = User.find_by_uuid(params[:gamer_id])
    filter_place_bet_incoming_request
    if user.blank?
      @error_code = '3000'
      @error_description = 'The gamer account does not exist.'
    else
      body = %Q|{
                  "Bet":{
                    "revision":"1",
                    "header":{
                      "userName":"#{@user_name}",
                      "password":"#{@password}",
                      "terminalID":#{@terminal_id},
                      "operatorID":#{@operator_id},
                      "operatorPIN":#{@operator_pin},
                      "auditID":#{@audit_id},
                      "messageID":#{@message_id},
                      "userID":1,
                      "dateTime":"#{@date_time}"
                    },
                    "content":{
                      "betCode":#{@bet_code},
                      "betModifier":#{@bet_modifier},
                      "selector1":#{@selector1},
                      "selector2":#{@selector2},
                      "repeats":#{@repeats},
                      "specialEntries":\[#{@special_entries}\],
                      "normalEntries":\[#{@normal_entries}\]
                    }
                  }
                }|

      request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/json"})

      request.on_complete do |response|
        if response.success?
          response_body = response.body
          json_response = (JSON.parse(response_body) rescue nil)

          if !json_response.blank?
            @error_code = (json_response["content"]["errorCode"] rescue nil)
            @error_description = (json_response["content"]["errorMessage"] rescue nil)

            if @error_code == 0 && (json_response["header"]["status"] == 'success' rescue nil)
              @bet = (json_response["content"] rescue nil)

              unless @bet.blank?
                ticket_number = (json_response["content"]["ticketNumber"] rescue nil)
                ref_number = (json_response["content"]["refNumber"] rescue nil)
                bet_cost_amount = (json_response["content"]["betCostAmount"] rescue nil)
                bet_payout_amount = (json_response["content"]["betPayoutAmount"] rescue nil)

                @ail_loto = AilLoto.create(transaction_id: @transaction_id, message_id: @message_id, audit_number: @audit_id, date_time: @date_time, bet_code: @bet_code, bet_modifier: @bet_modifier, selector1: @selector1, selector2: @selector2, repeats: @repeats, normal_entries: @normal_entries, special_entries: @special_entries, ticket_number: ticket_number, ref_number: ref_number, bet_cost_amount: bet_cost_amount, bet_payout_amount: bet_payout_amount, paymoney_account_number: paymoney_account_number, gamer_id: gamer_id, user_id: user.id, game_account_token: "AliXTtooY", draw_id: "#{DateTime.now.to_i}-#{@selector1}-#{@selector2}", begin_date: @begin_date, end_date: @end_date, draw_date: @draw_date, draw_number: @draw_number, basis_amount: @basis_amount)

                if place_bet_with_cancellation(@ail_loto, "AliXTtooY", paymoney_account_number, password, bet_cost_amount)
                  api_acknowledge_bet_old
                end

              end
            else
              @error_code = '4002'
              @error_description = "Votre pari n'a pas pu être placé."
            end

          else
            @error_code = '4001'
            @error_description = 'Error while parsing JSON.'
          end
        else
          @error_code = '4000'
          @error_description = "Le loto est momentanément indisponible, veuillez réessayer plus tard."
        end
      end

      request.run
    end

    AilLotoLog.create(operation: 'Prise de pari', transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def debit_paymoney_account(paymoney_account_number, transaction_amount)
    paymoney_account_token = check_account_number(paymoney_account_number)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    transaction_amount = transaction_amount.to_f.abs
    status = false

    if transaction_amount == 0
     @error_code = '5000'
     @error_description = "The transaction amount can't be 0."
    else
      if paymoney_account_token.blank?
        @error_code = '5001'
        @error_description = "The paymoney account have not been found."
      else
        #@eppl = Eppl.create(transaction_id: Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s, paymoney_account: params[:paymoney_account_number], transaction_amount: transaction_amount, remote_ip: remote_ip, paymoney_account_token: paymoney_account_token)
        request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/86d138798bc43ed59e5207c684564/bet/get/AliXTtooY/#{paymoney_account_token}/#{transaction_amount}", followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              @ail_loto.update_attributes(paymoney_transaction_id: response_body, bet_placed: true, bet_placed_at: DateTime.now, paymoney_account_token: paymoney_account_token)
              status = true
            else
              @error_code = '4001'
              @error_description = 'Payment error, could not checkout the account. Check the credit.'
              @ail_loto.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body, paymoney_account_token: paymoney_account_token)
            end
          else
            @error_code = '4000'
            @error_description = 'Cannot join paymoney wallet server.'
            @ail_loto.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body, paymoney_account_token: paymoney_account_token)
          end
        end

        request.run
      end
    end

    return status
  end

  def api_acknowledge_bet_old
    set_minimal_credentials
    status = false
    remote_ip_address = request.remote_ip
    url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/ackbet"
    @error_code = ''
    @error_description = ''
    response_body = ''
    @bet = (AilLoto.where("transaction_id = ?", @transaction_id).first rescue nil)

    if @bet.blank?
      @error_code = '4006'
      @error_description = 'Could not find the acknowledged transaction_id.'
    else
      if @bet.placement_acknowledge == true
        @error_code = '4007'
        @error_description = 'The bet has already been acknowledged.'
      else
        body = %Q|{
                  "Ack":{
                    "revision":"1",
                    "header":{
                      "userName":"#{@user_name}",
                      "password":"#{@password}",
                      "terminalID":#{@terminal_id},
                      "operatorID":#{@operator_id},
                      "operatorPIN":#{@operator_pin},
                      "auditID":#{@audit_id},
                      "messageID":#{@message_id},
                      "userID":1,
                      "dateTime":"#{@date_time}"
                    },
                    "content":{
                      "ticketNumber":"#{@bet.ticket_number}",
                      "refNumber":"#{@bet.ref_number}",
                      "reqType":0
                    }
                  }
                }|

        request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/json"})

        request.on_complete do |response|
          if response.success?
            response_body = response.body
            json_response = (JSON.parse(response_body) rescue nil)
            if !json_response.blank?
              @error_code = (json_response["content"]["errorCode"] rescue nil)
              @error_description = (json_response["content"]["errorMessage"] rescue nil)

              if @error_code == 0 && (json_response["header"]["status"] == 'success' rescue nil)
                @bet.update_attributes(placement_acknowledge: true, placement_acknowledge_date_time: DateTime.now.to_s, bet_status: "En cours")
                status = true
              else
                @error_code = '4005'
                @error_description = 'Could not acknowledge the bet.'
              end
            else
              @error_code = '4004'
              @error_description = 'Error while parsing JSON acknowlegement response.'
            end
          else
            @error_code = '4003'
            @error_description = 'Could not acknowledge the bet.'
          end
        end

        request.run
      end
    end

    AilLotoLog.create(operation: 'Confirmation de prise de pari', transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)

    return status
  end

  def api_cancel_bet
    set_credentials
    remote_ip_address = request.remote_ip
    url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/cancelbet"
    @error_code = ''
    @error_description = ''
    response_body = ''
    @bet = (AilLoto.where("transaction_id = ? AND placement_acknowledge IS TRUE", params[:transaction_id]).first rescue nil)

    if @bet.blank?
      @error_code = '4006'
      @error_description = "La transaction n'a pas été trouvée."
    else
      if DateTime.now > (@bet.created_at + 5.minute)
        @error_code = '4007'
        @error_description = "Le délai alloué pour l'annulation est dépassé."
      else
        if @bet.cancellation_acknowledge == true
          @error_code = '4007'
          @error_description = 'Le pari a déjà été annulé.'
        else
          body = %Q[{
                      "Bet":{
                        "revision":"1",
                        "header":{
                          "userName":"#{@user_name}",
                          "password":"#{@password}",
                          "terminalID":#{@terminal_id},
                          "operatorID":#{@operator_id},
                          "operatorPIN":#{@operator_pin},
                          "auditID":#{@audit_id},
                          "messageID":#{@message_id},
                          "userID":1,
                          "dateTime":"#{@date_time}"
                        },
                        "content":{
                          "ticketNumber":#{@bet.ticket_number},
                          "refNumber":#{@bet.ref_number}
                        }
                      }
                    }]

          request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/json"})

          request.on_complete do |response|
            if response.success?
              response_body = response.body
              json_response = (JSON.parse(response_body) rescue nil)

              if !json_response.blank?
                @error_code = (json_response["content"]["errorCode"] rescue nil)
                @error_description = (json_response["content"]["errorMessage"] rescue nil)

                if @error_code == 0 && (json_response["header"]["status"] == 'success' rescue nil)
                  @bet.update_attribute(:cancellation_acknowledge, false)

                  if cancel_bet(@bet)
                    if api_acknowledge_cancel_old(params[:transaction_id])
                      @bet = (json_response["content"] rescue nil)
                    end
                  end

                else
                  @error_code = '4002'
                  @error_description = 'Cannot cancel the bet.'
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

          AilLotoLog.create(operation: 'Annulation de pari', transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)
        end
      end
    end
  end

  def api_acknowledge_cancel_old(transaction_id)
    set_minimal_credentials
    status = false
    remote_ip_address = request.remote_ip
    url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/ackcancel"
    @error_code = ''
    @error_description = ''
    response_body = ''
    @bet = (AilLoto.where("transaction_id = ? AND cancellation_acknowledge IS FALSE", transaction_id).first rescue nil)

    if @bet.blank?
      @error_code = '4006'
      @error_description = 'Could not find the acknowledged transaction_id.'
    else
      if @bet.cancellation_acknowledge == true
        @error_code = '4007'
        @error_description = 'The bet has already been cancelled.'
      else
        body = %Q|{
                  "Ack":{
                    "revision":"1",
                    "header":{
                      "userName":"#{@user_name}",
                      "password":"#{@password}",
                      "terminalID":#{@terminal_id},
                      "operatorID":#{@operator_id},
                      "operatorPIN":#{@operator_pin},
                      "auditID":#{@audit_id},
                      "messageID":#{@message_id},
                      "userID":1,
                      "dateTime":"#{@date_time}"
                    },
                    "content":{
                      "ticketNumber":#{@bet.ticket_number},
                      "refNumber":#{@bet.ref_number},
                      "reqType":0
                    }
                  }
                }|

        request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/json"})

        request.on_complete do |response|
          if response.success?
            response_body = response.body
            json_response = (JSON.parse(response_body) rescue nil)
            if !json_response.blank?
              @error_code = (json_response["content"]["errorCode"] rescue nil)
              @error_description = (json_response["content"]["errorMessage"] rescue nil)

              if @error_code == 0 && (json_response["header"]["status"] == 'success' rescue nil)
                @bet.update_attributes(cancellation_acknowledge: true, cancellation_acknowledge_date_time: DateTime.now.to_s, bet_status: "Annulé")
                status = true
              else
                @error_code = '4005'
                @error_description = 'Could not acknowledge the bet.'
              end
            else
              @error_code = '4004'
              @error_description = 'Error while parsing JSON acknowlegement response.'
            end
          else
            @error_code = '4003'
            @error_description = 'Could not acknowledge the bet.'
          end
        end

        request.run
      end
    end

    AilLotoLog.create(operation: "Confirmation d'annulation de prise de pari", transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)

    return status
  end

  def api_refund_bet
    set_credentials
    remote_ip_address = request.remote_ip
    url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/refundbet"
    @error_code = ''
    @error_description = ''
    response_body = ''
    @bet = (AilLoto.where("transaction_id = ? AND placement_acknowledge IS TRUE", params[:transaction_id]).first rescue nil)

    if @bet.blank?
      @error_code = '4006'
      @error_description = 'Could not find the acknowledged transaction_id.'
    else
      if @bet.refund_acknowledge == true
        @error_code = '4007'
        @error_description = 'The bet have already been refunded.'
      else
        body = %Q[{
                    "Bet":{
                      "revision":"1",
                      "header":{
                        "userName":"#{@user_name}",
                        "password":"#{@password}",
                        "terminalID":#{@terminal_id},
                        "operatorID":#{@operator_id},
                        "operatorPIN":#{@operator_pin},
                        "auditID":#{@audit_id},
                        "messageID":#{@message_id},
                        "userID":1,
                        "dateTime":"#{@date_time}"
                      },
                      "content":{
                        "ticketNumber":#{@bet.ticket_number},
                        "refNumber":#{@bet.ref_number}
                      }
                    }
                  }]

        request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/json"})

        request.on_complete do |response|
          if response.success?
            response_body = response.body
            json_response = (JSON.parse(response_body) rescue nil)

            if !json_response.blank?
              @error_code = (json_response["content"]["errorCode"] rescue nil)
              @error_description = (json_response["content"]["errorMessage"] rescue nil)

              if @error_code == 0 && (json_response["header"]["status"] == 'success' rescue nil)
                if api_acknowledge_refund_old(params[:transaction_id])
                  @bet = (json_response["content"] rescue nil)
                end
              else
                @error_code = '4002'
                @error_description = 'Cannot refund the bet.'
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

        AilLotoLog.create(operation: 'Remboursement de pari', transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)
      end
    end
  end

  def api_acknowledge_refund_old(transaction_id)
    set_minimal_credentials
    status = false
    remote_ip_address = request.remote_ip
    url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/ackrefund"
    @error_code = ''
    @error_description = ''
    response_body = ''
    @bet = (AilLoto.where("transaction_id = ? AND transaction_acknowledge IS TRUE AND cancellation_acknowledge IS NULL FALSE", transaction_id).first rescue nil)

    if @bet.blank?
      @error_code = '4006'
      @error_description = 'Could not find the acknowledged transaction_id.'
    else
      if @bet.refund_acknowledge == true
        @error_code = '4007'
        @error_description = 'The bet has already been refunded.'
      else
        body = %Q|{
                  "Ack":{
                    "revision":"1",
                    "header":{
                      "userName":"#{@user_name}",
                      "password":"#{@password}",
                      "terminalID":#{@terminal_id},
                      "operatorID":#{@operator_id},
                      "operatorPIN":#{@operator_pin},
                      "auditID":#{@audit_id},
                      "messageID":#{@message_id},
                      "userID":1,
                      "dateTime":"#{@date_time}"
                    },
                    "content":{
                      "ticketNumber":#{@bet.ticket_number},
                      "refNumber":#{@bet.ref_number},
                      "reqType":0
                    }
                  }
                }|

        request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/json"})

        request.on_complete do |response|
          if response.success?
            response_body = response.body
            json_response = (JSON.parse(response_body) rescue nil)
            if !json_response.blank?
              @error_code = (json_response["content"]["errorCode"] rescue nil)
              @error_description = (json_response["content"]["errorMessage"] rescue nil)

              if @error_code == 0 && (json_response["header"]["status"] == 'success' rescue nil)
                @bet.update_attributes(refund_acknowledge: true, refund_acknowledge_date_time: DateTime.now.to_s)
                status = true
              else
                @error_code = '4005'
                @error_description = 'Could not acknowledge the bet.'
              end
            else
              @error_code = '4004'
              @error_description = 'Error while parsing JSON acknowlegement response.'
            end
          else
            @error_code = '4003'
            @error_description = 'Could not acknowledge the bet.'
          end
        end

        request.run
      end
    end

    AilLotoLog.create(operation: "Confirmation d'annulation de remboursement", transaction_id: transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)

    return status
  end

  def api_bet_details
    @error_code = ''
    @error_description = ''
    @bet = AilLoto.find_by_transaction_id(params[:transaction_id])

    if @bet.blank?
      @error_code = '4000'
      @error_description = 'The transaction id could not be found'
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
      @bets = user.ail_lotos.order("created_at DESC") rescue nil
    end
  end

  # Les notifications sont reçues et mises en attente
  def api_validate_transaction
    @error_code = ''
    @error_description = ''
    raw_data = request.body.read
    notification_objects = (JSON.parse(raw_data) rescue nil)
    bets = notification_objects["bets"] rescue ""
    error_array = []
    success_array = []
    draw_id_array = []
    remote_ip_address = request.remote_ip

    if notification_objects.blank? || (bets.class.to_s rescue nil) != "Array"
      @error_code = '5000'
      @error_description = 'Invalid JSON data.'
    else
      audit_id = notification_objects["AuditId"] rescue ""
      message_id = notification_objects["messageID"] rescue ""
      message_type = set_message_type(notification_objects["messageType"])

      AilLotoLog.create(operation: message_type, sent_params: raw_data, remote_ip_address: remote_ip_address)

      if message_type == "Notification"
        bets.each do |notification_object|
          ref_number = notification_object["RefNumber"] rescue ""
          ticket_number = notification_object["TicketNumber"] rescue ""
          amount = notification_object["Amount"] rescue ""
          amount_type = notification_object["OperationType"].to_s rescue ""

          @bet = AilLoto.where(ref_number: ref_number, ticket_number: ticket_number, earning_paid: nil, refund_paid: nil, earning_notification_received: nil, refund_notification_received: nil).first rescue nil
          if @bet.blank? || !["1", "2"].include?(amount_type)
            error_array << notification_object.to_s
          else
            success_array << notification_object.to_s

            if amount_type == "1"
              notification_field = "earning"
            else
              notification_field = "refund"
            end

            @bet.update_attributes(:"#{notification_field}_notification_received" => true, :"#{notification_field}_amount" => amount, :"#{notification_field}_notification_received_at" => DateTime.now, bet_status: "En attente de validation")
          end
        end
      end

      if message_type == "Correction"
        bets.each do |notification_object|
          ref_number = notification_object["RefNumber"] rescue ""
          ticket_number = notification_object["TicketNumber"] rescue ""
          amount = notification_object["NewAmount"] rescue ""
          amount_type = notification_object["NewOperationType"].to_s rescue ""

          @bet = AilLoto.where("ticket_number = '#{ticket_number}' AND earning_paid IS NULL AND refund_paid IS NULL AND (earning_notification_received IS TRUE OR refund_notification_received IS TRUE)").first rescue nil
          if @bet.blank? || !["1", "2"].include?(amount_type)
            error_array << notification_object.to_s
          else
            success_array << notification_object.to_s

            if amount_type == "1"
              notification_field = "earning"
            else
              notification_field = "refund"
            end

            if ref_number == "4"
              @bet.update_attributes(:"#{notification_field}_notification_received" => true, :"#{notification_field}_amount" => 0, bet_status: "En attente de validation")
            else
              @bet.update_attributes(:"#{notification_field}_notification_received" => true, :"#{notification_field}_amount" => amount, bet_status: "En attente de validation")
            end
          end
        end
      end

    end

    render text: %Q[{
        "success":#{success_array},
        "error": #{error_array}
      }
    ]

  end

  def set_message_type(message_type)
    result = message_type

    if message_type != "Correction"
      result = "Notification"
    end

    return result
  end

  def validate_payment_notifications
    bets = AilLoto.where("(earning_notification_received IS TRUE OR refund_notification_received IS TRUE) AND bet_status = 'En attente de validation' AND placement_acknowledge IS TRUE AND (earning_notification_received_at  < '#{DateTime.now - 16.minutes}' OR refund_notification_received_at  < '#{DateTime.now - 16.minutes}') AND earning_paid IS NULL AND refund_paid IS NULL")
    draw_ids = bets.pluck(:draw_id) rescue nil

    unless draw_ids.blank?

      draw_ids.each do |draw_id|
        bets = AilLoto.where(earning_paid: nil, refund_paid: nil, draw_id: draw_id, placement_acknowledge: true)
        bets_amount = bets.map{|bet| (bet.earning_amount.to_f rescue 0) + (bet.refund_amount.to_f rescue 0)}.sum rescue 0
        if validate_bet_ail("ApXTrliOp", bets_amount, "ail_lotos")
          bets_payout = AilLoto.where("earning_notification_received IS TRUE AND draw_id = '#{draw_id}' AND paymoney_earning_id IS NULL")
          unless bets_payout.blank?
            bets_payout.each do |bet_payout|
              pay_ail_earnings(bet_payout, "AliXTtooY", bet_payout.earning_amount, "earning")

              # SMS notification
              build_message(bet_payout, bet_payout.earning_amount, "au LOTO", bet_payout.ticket_number)
              send_sms_notification(bet_payout, @msisdn, "LOTO", @message_content)

              # Email notification
              WinningNotification.notification_email(bet_payout.user, bet_payout.earning_amount, "au LOTO", "LOTO", bet_payout.ticket_number).deliver
            end
          end

          bets_refund = AilLoto.where("refund_notification_received IS TRUE AND draw_id = '#{draw_id}' AND paymoney_refund_id IS NULL")
          unless bets_refund.blank?
            bets_refund.each do |bet_refund|
              pay_ail_earnings(bet_refund, "AliXTtooY", bet_refund.refund_amount, "refund")

              # SMS notification
              build_message(bet_refund, bet_refund.refund_amount, "au LOTO", bet_refund.ticket_number)
              send_sms_notification(bet_refund, @msisdn, "LOTO", @message_content)

              # Email notification
              WinningNotification.notification_email(bet_refund.user, bet_refund.refund_amount, "au LOTO", "LOTO", bet_refund.ticket_number).deliver
            end
          end

          AilLoto.where("draw_id = '#{draw_id}' AND earning_paid IS NULL AND refund_paid IS NULL AND placement_acknowledge").map{|bet| bet.update_attributes(bet_satus: "Perdant")}
        end
      end
    end

    #render text: "0"
  end

  def backup_api_validate_transaction
    @error_code = ''
    @error_description = ''
    notification_objects = (JSON.parse(request.body.read) rescue nil)
    bets = notification_objects["bets"] rescue ""
    error_array = []
    success_array = []
    draw_id_array = []
    remote_ip_address = request.remote_ip



    if notification_objects.blank? || (bets.class.to_s rescue nil) != "Array"
      @error_code = '5000'
      @error_description = 'Invalid JSON data.'
    else
      audit_id = notification_objects["AuditId"] rescue ""
      message_id = notification_objects["messageID"] rescue ""
      message_type = notification_objects["messageType"] rescue ""

       AilLotoLog.create(operation: (message_type == "Correction" ? "Correction" : "Notification"), sent_params: request.body.read, remote_ip_address: remote_ip_address)

      bets.each do |notification_object|

        ref_number = notification_object["RefNumber"] rescue ""
        ticket_number = notification_object["TicketNumber"] rescue ""
        amount = notification_object["Amount"] rescue ""
        amount_type = notification_object["OperationType"].to_s rescue ""

        @bet = AilLoto.where(ref_number: ref_number, ticket_number: ticket_number, earning_paid: nil, refund_paid: nil).first rescue nil
        if @bet.blank? || !["1", "2"].include?(amount_type)
          error_array << notification_object.to_s
        else
          success_array << notification_object.to_s
          unless draw_id_array.include?(@bet.draw_id)
            draw_id_array << @bet.draw_id
          end
          if amount_type == "1"
            @bet.update_attributes(earning_notification_received: true, earning_amount: amount, earning_notification_received_at: DateTime.now)
          else
            @bet.update_attributes(refund_notification_received: true, refund_amount: amount, refund_notification_received_at: DateTime.now)
          end
        end
      end

      draw_id_array.each do |draw_id|
        bets = AilLoto.where(earning_paid: nil, refund_paid: nil, draw_id: draw_id, placement_acknowledge: true)
        unless bets.blank?

          bets_amount = bets.map{|bet| (bet.earning_amount.to_f rescue 0) + (bet.refund_amount.to_f rescue 0)}.sum rescue 0
          if validate_bet_ail("ApXTrliOp", bets_amount, "ail_pmus")
            bets_payout = AilLoto.where("earning_notification_received IS TRUE AND draw_id = '#{draw_id}' AND paymoney_earning_id IS NULL")
            unless bets_payout.blank?
              bets_payout.each do |bet_payout|
                pay_ail_earnings(bet_payout, "AliXTtooY", bet_payout.earning_amount, "earning")

                # SMS notification
                build_message(bet_payout, bet_payout.earning_amount, "au LOTO", bet_payout.ticket_number)
                send_sms_notification(bet_payout, @msisdn, "LOTO", @message_content)

                # Email notification
                WinningNotification.notification_email(bet_payout.user, bet_payout.earning_amount, "au LOTO", "LOTO", bet_payout.ticket_number).deliver
              end
            end

            bets_refund = AilLoto.where("refund_notification_received IS TRUE AND draw_id = '#{draw_id}' AND paymoney_refund_id IS NULL")
            unless bets_refund.blank?
              bets_refund.each do |bet_refund|
                pay_ail_earnings(bet_refund, "AliXTtooY", bet_refund.refund_amount, "refund")

                # SMS notification
                build_message(bet_refund, bet_refund.refund_amount, "au LOTO", bet_refund.ticket_number)
                send_sms_notification(bet_refund, @msisdn, "LOTO", @message_content)

                # Email notification
                WinningNotification.notification_email(bet_refund.user, bet_refund.refund_amount, "au LOTO", "LOTO", bet_refund.ticket_number).deliver
              end
            end
          end

        end

        AilLoto.where("draw_id = '#{draw_id}' AND earning_paid IS NULL AND refund_paid IS NULL AND placement_acknowledge").map{|bet| bet.update_attributes(bet_satus: "Perdant")}
      end
    end


    render text: %Q[{
        "success":#{success_array},
        "error": #{error_array}
      }
    ]

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
      @draw_day = json_request["draw_day"]
      @draw_number = json_request["draw_number"]
      @begin_date = json_request["begin_date"]
      @end_date = json_request["end_date"]
      @basis_amount = json_request["basis_amount"] rescue ""
    end
  end

  def api_last_request_log
    @previous_operation = AilLotoLog.find(AilLotoLog.last.id - 1) rescue ""
    @last_operation = AilLotoLog.last rescue ""

    render text: "---Operation: " + (@previous_operation.operation || "") + "\n\n---Transaction ID: " +  (@previous_operation.transaction_id || "") + "\n\n---Sent params: " +  (@previous_operation.sent_params || "") + "\n\n---Response: " +  (@previous_operation.response_body || "") + "\n\n\n\n---Operation: " + (@last_operation.operation || "") + "\n\n---Transaction ID: " + (@last_operation.transaction_id || "") + "\n\n---Sent params: " + (@last_operation.sent_params || "") + "\n\n---Response: " + (@last_operation.response_body || "")
  end
end
