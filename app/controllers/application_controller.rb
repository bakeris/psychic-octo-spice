class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def place_bet_with_cancellation(bet, game_account_token, paymoney_account_number, password, transaction_amount)
    paymoney_account_token = check_account_number(paymoney_account_number)

    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    transaction_amount = transaction_amount.to_f.abs
    status = false

    if transaction_amount == 0
     @error_code = '5000'
     @error_description = "Le montant de transaction ne peut pas être nul."
    else
      if paymoney_account_token.blank?
        @error_code = '5001'
        @error_description = "Le compte Paymoney n'a pas été trouvé."
      else
        request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/86d138798bc43ed59e5207c684564/bet/get/#{bet.transaction_id}/#{game_account_token}/#{paymoney_account_token}/#{password}/#{transaction_amount}", followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              bet.update_attributes(paymoney_transaction_id: response_body, bet_placed: true, bet_placed_at: DateTime.now, paymoney_account_token: paymoney_account_token)
              status = true
            else
              @error_code = '4001'
              @error_description = "Le compte Paymoney n'a pas pu être débité. Veuillez vérifier votre crédit."
              bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body, paymoney_account_token: paymoney_account_token)
            end
          else
            @error_code = '4000'
            @error_description = 'Le serveur de paiement est inaccessible.'
            bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body, paymoney_account_token: paymoney_account_token)
          end
        end

        request.run
      end
    end

    return status
  end

  def place_cm3_bet_with_cancellation(bet, game_account_token, paymoney_account_number, password, transaction_amount)
    paymoney_account_token = check_account_number(paymoney_account_number)

    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    transaction_amount = transaction_amount.to_f.abs
    status = false

    if transaction_amount == 0
     @error_code = '5000'
     @error_description = "Le montant de transaction ne peut pas être nul."
    else
      if paymoney_account_token.blank?
        @error_code = '5001'
        @error_description = "Le compte Paymoney n'a pas été trouvé."
      else
        body = "#{paymoney_wallet_url}/api/86d138798bc43ed59e5207c684564/bet/get/#{bet.sale_client_id}/#{game_account_token}/#{paymoney_account_token}/#{password}/#{transaction_amount}"
        request = Typhoeus::Request.new(body, followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              bet.update_attributes(p_payment_transaction_id: response_body, p_payment_request: body, paymoney_account_token: paymoney_account_token, p_payment_response: response_body)
              status = true
            else
              @error_code = '4001'
              @error_description = "Le compte Paymoney n'a pas pu être débité. Veuillez vérifier votre crédit."
              bet.update_attributes(payment_error_code: @error_code, payment_error_description: @error_description, p_payment_request: body, paymoney_account_token: paymoney_account_token, p_payment_response: response_body)
            end
          else
            @error_code = '4000'
            @error_description = 'Le serveur de paiement est inaccessible.'
            bet.update_attributes(payment_error_code: @error_code, payment_error_description: @error_description, p_payment_request: body, paymoney_account_token: paymoney_account_token)
          end
        end

        request.run
      end
    end

    return status
  end

  def place_bet_without_cancellation(bet, game_account_token, paymoney_account_number, password, transaction_amount)
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
        request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/9b04e57f135f05bc05b5cf6d9b0d8/bet/get/#{bet.transaction_id}/#{game_account_token}/#{paymoney_account_token}/#{password}/#{transaction_amount}", followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              bet.update_attributes(paymoney_transaction_id: response_body, bet_placed: true, bet_placed_at: DateTime.now, paymoney_account_token: paymoney_account_token)
              status = true
            else
              @error_code = '4001'
              @error_description = 'Payment error, could not checkout the account. Check the credit.'
              bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body, paymoney_account_token: paymoney_account_token)
            end
          else
            @error_code = '4000'
            @error_description = 'Cannot join paymoney wallet server.'
            bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body, paymoney_account_token: paymoney_account_token)
          end
        end

        request.run
      end
    end

    return status
  end

  def validate_bet(game_account_token, transaction_amount)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false

    request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/06331525768e6a95680c8bb0dcf55/bet/validate/#{game_account_token}/#{transaction_amount}", followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          ActiveRecord::Base.connection.execute("UPDATE eppls SET paymoney_validation_id = '#{response_body}', bet_validated = TRUE, bet_validated_at = '#{DateTime.now}' WHERE game_account_token = '#{game_account_token}' AND bet_validated IS NULL")
          #bet.update_attributes(paymoney_transaction_id: response_body, bet_placed: true, bet_placed_at: DateTime.now)
          status = true
        else
          @error_code = '5000'
          ActiveRecord::Base.connection.execute("UPDATE eppls SET error_code = '#{@error_code}', error_description = '#{response_body}' WHERE game_account_token = '#{game_account_token}' AND bet_validated IS NULL")
          #bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
        end
      else
        @error_code = '4000'
        @error_description = 'Cannot join paymoney wallet server.'
        ActiveRecord::Base.connection.execute("UPDATE eppls SET error_code = '#{@error_code}', error_description = '#{@error_description}' WHERE game_account_token = '#{game_account_token}' AND bet_validated IS NULL")
      end
    end

    request.run

    return status
  end

  def validate_bet_ail(game_account_token, transaction_amount, ail_object)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false

    request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/06331525768e6a95680c8bb0dcf55/bet/validate/#{game_account_token}/#{transaction_amount}", followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          ActiveRecord::Base.connection.execute("UPDATE #{ail_object} SET paymoney_validation_id = '#{response_body}', bet_validated = TRUE, bet_validated_at = '#{DateTime.now}' WHERE game_account_token = '#{game_account_token}' AND bet_validated IS NULL")
          #bet.update_attributes(paymoney_transaction_id: response_body, bet_placed: true, bet_placed_at: DateTime.now)
          status = true
        else
          @error_code = '5000'
          ActiveRecord::Base.connection.execute("UPDATE #{ail_object} SET error_code = '#{@error_code}', error_description = '#{response_body}' WHERE game_account_token = '#{game_account_token}' AND bet_validated IS NULL")
          #bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
        end
      else
        @error_code = '4000'
        @error_description = 'Cannot join paymoney wallet server.'
        ActiveRecord::Base.connection.execute("UPDATE #{ail_object} SET error_code = '#{@error_code}', error_description = '#{@error_description}' WHERE game_account_token = '#{game_account_token}' AND bet_validated IS NULL")
      end
    end

    request.run

    return status
  end

  def validate_bet_cm3(game_account_token, transaction_amount, race_id)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false

    request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/06331525768e6a95680c8bb0dcf55/bet/validate/#{game_account_token}/#{transaction_amount}", followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          ActiveRecord::Base.connection.execute("UPDATE cms SET p_validation_id = '#{response_body}', p_validated = TRUE, p_validated_at = '#{DateTime.now}' WHERE win_reason IS NOT NULL AND race_id = '#{race_id}' AND p_validated IS NULL")
          #bet.update_attributes(paymoney_transaction_id: response_body, bet_placed: true, bet_placed_at: DateTime.now)
          status = true
        else
          @error_code = '5000'
          ActiveRecord::Base.connection.execute("UPDATE cms SET p_validation_response = '#{response_body}' WHERE win_reason IS NOT NULL AND race_id = '#{race_id}' AND p_validated IS NULL")
          #bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
        end
      else
        @error_code = '4000'
        @error_description = "Le serveur de paiement n'est pas accessible."
        ActiveRecord::Base.connection.execute("UPDATE cms SET p_validation_response = '#{response_body}' WHERE win_reason IS NOT NULL AND race_id = '#{race_id}' AND p_validated IS NULL")
      end
    end

    request.run

    return status
  end

  def cancel_bet(bet)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false

    request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/35959d477b5ffc06dc673befbe5b4/bet/payback/#{bet.transaction_id}", followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          bet.update_attributes(cancellation_paymoney_id: response_body, bet_cancelled: true, bet_cancelled_at: DateTime.now)
          status = true
        else
          @error_code = '4001'
          @error_description = 'Payment error, could not cancel the bet.'
          bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
        end
      else
        @error_code = '4000'
        @error_description = 'Cannot join paymoney wallet server.'
        bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
      end
    end

    request.run

    return status
  end

  def cancel_cm3_bet(bet)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false
    request_body = "#{paymoney_wallet_url}/api/35959d477b5ffc06dc673befbe5b4/bet/payback/#{bet.transaction_id}"

    request = Typhoeus::Request.new(request_body, followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          bet.update_attributes(cancel_request: request_body, p_cancellation_id: response_body, cancelled: true, cancelled_at: DateTime.now)
          status = true
        else
          @error_code = '4001'
          @error_description = "Erreur de paiement, le pari n'a pas pu être annulé."
          bet.update_attributes(cancel_request: request_body, cancel_response: response_body, cancel_response: response_body)
        end
      else
        @error_code = '4000'
        @error_description = 'Le serveur de paiement est indisponible.'
        bet.update_attributes(cancel_request: request_body)
      end
    end

    request.run

    return status
  end

  def pay_earnings(bet, game_account_token, transaction_amount)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false

    request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/86d1798bc43ed59e5207c68e864564/earnings/pay/#{game_account_token}/#{bet.paymoney_account_token}/#{bet.transaction_id}/#{transaction_amount}", followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          bet.update_attributes(payment_paymoney_id: response_body, earning_paid: true, earning_paid_at: DateTime.now)
          status = true
        else
          @error_code = '4001'
          @error_description = "Erreur de paiement, votre paiement n'a pas pu être effectué."
          bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
        end
      else
        @error_code = '4000'
        @error_description = "Le serveur de paiement n'est pas disponible."
        bet.update_attributes(error_code: @error_code, error_description: @error_description)
      end
    end

    request.run

    return status
  end

  def pay_ail_earnings(bet, game_account_token, transaction_amount, payment_type)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false

    request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/86d1798bc43ed59e5207c68e864564/earnings/pay/#{game_account_token}/#{bet.paymoney_account_token}/#{bet.transaction_id}/#{transaction_amount}", followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          bet.update_attributes(paymoney_earning_id: response_body, :"#{payment_type}_paid" => true, :"#{payment_type}_paid_at" => DateTime.now, bet_status: "Gagnant")
          status = true
        else
          @error_code = '4001'
          @error_description = 'Erreur de paiement.'
          bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
        end
      else
        @error_code = '4000'
        @error_description = "Le serveur de paiement n'est pas disponible."
        bet.update_attributes(error_code: @error_code, error_description: @error_description)
      end
    end

    request.run

    return status
  end

  def check_account_number(account_number)
    token = (RestClient.get "http://94.247.178.141:8080/PAYMONEY_WALLET/rest/check2_compte/#{account_number}" rescue "")

    return token
  end

  def send_sms_notification(bet, msisdn, sender, message_content)
    request = Typhoeus::Request.new("http://smsplus3.routesms.com:8080/bulksms/bulksms?username=ngser1&password=abcd1234&type=0&dlr=1&destination=225#{msisdn}&source=#{sender}&message=#{URI.escape(message_content)}", followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        result = response.body.strip.split("|") rescue nil
        if result[0] == "1701"
          bet.update_attributes(sms_sent: true, sms_content: message_content, sms_id: (result[2] rescue ""), sms_status: result[0])
        else
          bet.update_attributes(sms_sent: false, sms_content: message_content, sms_status: result[0])
        end
      end
    end

    request.run
  end

  def build_message(bet, amount, game, ticket_number)
    @user = User.find_by_uuid(bet.gamer_id)
    @msisdn = @user.msisdn rescue ""
    @message_content = %Q[
      Vous avez gagné #{amount} F en jouant #{amount} sur PARIONS DIRECT.
      Num ticket: #{ticket_number}. Votre compte PAYMONEY LONACI vient d'être rechargé. CONTINUE DE JOUER ET GAGNE DIRECT.]
  end

  # Check if the parameter is not a number
  def not_a_number?(n)
  	n.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? true : false
  end
end
