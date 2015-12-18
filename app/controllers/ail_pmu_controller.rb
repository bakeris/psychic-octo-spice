class AilPmuController < ApplicationController

  def set_credentials
    @user_name = "pmu@test.co.za"
    @password = "dljghh$fdhfd@dj"
    @terminal_id = "100000"
    @operator_id = "1"
    @operator_pin = "1"
    @audit_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..8]
    @message_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..7]
    @transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s
    @user_id = "1"
    #@confirm_id = (AilPmu.last.transaction_id rescue "")
    @date_time = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
  end

  def set_minimal_credentials
    @audit_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..8]
    @message_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..7]
  end

  def api_get_draws
    set_credentials
    remote_ip_address = request.remote_ip
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

    AilPmuLog.create(operation: 'Liste complète des tirages', transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)
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
              url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/ackbet"
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

    AilPmuLog.create(operation: 'Consultation de pari', transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)
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
    user = User.find_by_uuid(params[:gamer_id])
    gamer_id = params[:gamer_id]
    password = params[:password]
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
    if user.blank?
      @error_code = '3000'
      @error_description = 'The gamer account does not exist.'
    else
      request = Typhoeus::Request.new(url, body: body, followlocation: true, method: :post, headers: {'Content-Type'=> "application/json"})

      request.on_complete do |response|
        if response.success?
          response_body = response.body
          json_response = (JSON.parse(response_body))

          if !json_response.blank?
            @error_code = (json_response["content"]["errorCode"])
            @error_description = (json_response["content"]["errorMessage"])

            if @error_code == 0 && (json_response["header"]["status"] == 'success')
              @bet = (json_response["content"] rescue nil)

              unless @bet.blank?
                ticket_number = (json_response["content"]["ticketNumber"] rescue nil)
                ref_number = (json_response["content"]["refNumber"] rescue nil)
                bet_cost_amount = (json_response["content"]["betCostAmount"] rescue nil)
                bet_payout_amount = (json_response["content"]["betPayoutAmount"] rescue nil)

                @ail_pmu = AilPmu.create(transaction_id: @transaction_id, message_id: @message_id, audit_number: @audit_id, date_time: @date_time, bet_code: @bet_code, bet_modifier: @bet_modifier, selector1: @selector1, selector2: @selector2, repeats: @repeats, normal_entries: @normal_entries, special_entries: @special_entries, ticket_number: ticket_number, ref_number: ref_number, bet_cost_amount: bet_cost_amount, bet_payout_amount: bet_payout_amount, paymoney_account_number: paymoney_account_number, gamer_id: gamer_id, user_id: user.id, game_account_token: "ApXTrliOp", draw_id: "#{DateTime.now.to_i}-#{@selector1}-#{@selector2}")

                if place_bet_with_cancellation(@ail_pmu, "uXAXMDuW", paymoney_account_number, password, bet_cost_amount)
                  api_acknowledge_bet_old
                end

              end
            else
              @error_code = '4002'
              @error_description = "Le pari n'a pas pu être pris."
            end

          else
            @error_code = '4001'
            @error_description = 'Erreur lors du parsing de la réponse JSON.'
          end
        else
          @error_code = '4000'
          @error_description = 'Ressource non disponible.'
        end
      end

      request.run
    end

    AilPmuLog.create(operation: 'Prise de pari', transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)
  end

  def api_acknowledge_bet_old
    set_minimal_credentials
    status = false
    remote_ip_address = request.remote_ip
    url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/ackbet"
    @error_code = ''
    @error_description = ''
    response_body = ''
    @bet = (AilPmu.where("transaction_id = ?", @transaction_id).first rescue nil)

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
                @bet.update_attributes(placement_acknowledge: true, placement_acknowledge_date_time: DateTime.now.to_s)
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

    AilPmuLog.create(operation: 'Confirmation de prise de pari', transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)

    return status
  end

  def api_cancel_bet
    set_credentials
    remote_ip_address = request.remote_ip
    url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/cancelbet"
    @error_code = ''
    @error_description = ''
    response_body = ''
    transaction_id = params[:transaction_id]
    @bet = (AilPmu.where("transaction_id = ? AND placement_acknowledge IS TRUE", transaction_id).first rescue nil)

    if @bet.blank?
      @error_code = '4006'
      @error_description = 'Could not find the acknowledged transaction_id.'
    else
      if @bet.cancellation_acknowledge == true
        @error_code = '4007'
        @error_description = 'The bet have already been canceled.'
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

        AilPmuLog.create(operation: 'Annulation de pari', transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)
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
    @bet = (AilPmu.where("transaction_id = ? AND cancellation_acknowledge IS FALSE", transaction_id).first rescue nil)

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
                @bet.update_attributes(cancellation_acknowledge: true, cancellation_acknowledge_date_time: DateTime.now.to_s)
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

    AilPmuLog.create(operation: "Confirmation d'annulation de prise de pari", transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)

    return status
  end

  def api_refund_bet
    set_credentials
    remote_ip_address = request.remote_ip
    url = "http://office.rtsapps.co.za/RTS_AVTBet_ws_V1/AVTBetV1.svc/bet/refundbet"
    @error_code = ''
    @error_description = ''
    response_body = ''
    @bet = (AilPmu.where("transaction_id = ? AND placement_acknowledge IS TRUE", params[:transaction_id]).first rescue nil)

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

        AilPmuLog.create(operation: 'Remboursement de pari', transaction_id: @transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)
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
    @bet = (AilPmu.where("transaction_id = ? AND transaction_acknowledge IS TRUE AND cancellation_acknowledge IS NULL FALSE", transaction_id).first rescue nil)

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

    AilPmuLog.create(operation: "Confirmation d'annulation de remboursement", transaction_id: transaction_id, error_code: @error_code, sent_params: body, response_body: response_body, remote_ip_address: remote_ip_address)

    return status
  end

  def api_bet_details
    @error_code = ''
    @error_description = ''
    @bet = AilPmu.find_by_transaction_id(params[:transaction_id])

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
      @bets = user.ail_pmus
    end
  end

  def api_validate_transaction
    @error_code = ''
    @error_description = ''
    notification_objects = (JSON.parse(request.body.read) rescue nil)
    notification_objects = notification_objects["bets"]
    error_array = []
    success_array = []
    draw_id_array = []

    if notification_objects.blank? || (notification_objects.class.to_s rescue nil) != "Array"
      @error_code = '5000'
      @error_description = 'Invalid JSON data.'
    else
      #audit_id = notification_objects["AuditId"] rescue ""
      notification_objects.each do |notification_object|

        ref_number = notification_object["RefNumber"] rescue ""
        ticket_number = notification_object["TicketNumber"] rescue ""
        amount = notification_object["Amount"] rescue ""
        amount_type = notification_object["AmountType"].to_s rescue ""

        @bet = AilPmu.where(ref_number: ref_number, ticket_number: ticket_number, earning_paid: nil, refund_paid: nil).first rescue nil
        print @bet.blank?.to_s + "**********************"
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
        bets = AilPmu.where(earning_paid: nil, refund_paid: nil, draw_id: draw_id, placement_acknowledge: true)
        unless bets.blank?

          bets_amount = bets.map{|bet| (bet.earning_amount.to_f rescue 0) + (bet.refund_amount.to_f rescue 0)}.sum rescue 0
          if validate_bet_ail("ApXTrliOp", bets_amount, "ail_pmus")
            bets_payout = AilPmu.where("earning_notification_received IS TRUE AND draw_id = '#{draw_id}' AND paymoney_earning_id IS NULL")
            unless bets_payout.blank?
              bets_payout.each do |bet_payout|
                pay_ail_earnings(bet_payout, "ApXTrliOp", bet_payout.earning_amount, "earning")
              end
            end

            bets_refund = AilPmu.where("refund_notification_received IS TRUE AND draw_id = '#{draw_id}' AND paymoney_refund_id IS NULL")
            unless bets_refund.blank?
              bets_refund.each do |bet_refund|
                pay_ail_earnings(bet_refund, "ApXTrliOp", bet_refund.refund_amount, "refund")
              end
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

  def api_last_request_log
    render text: "---Operation: " + AilPmuLog.last.operation + "\n\n---Transaction ID: " + AilPmuLog.last.transaction_id  + "\n\n---Sent params: " + AilPmuLog.last.sent_params + "\n\n---Response: " + AilPmuLog.last.response_body
  end

end
