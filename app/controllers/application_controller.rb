class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?

  def select_administrator_profile
    @game_administrator = false
    @profile = current_administrator.profile rescue nil
    unless @profile.blank?
      if @profile.pmu_plr_right == true || @profile.pmu_alr_right == true || @profile.loto_right == true || @profile.spc_right == true || @profile.eppl_right == true
        @game_administrator = true
      end
    end
  end

  def disconnect_profiless_users
    if current_administrator.blank? || current_administrator.profile.blank?
      sign_out(current_administrator) rescue nil
      flash[:alert] = "Votre compte n'a aucun profil."
      redirect_to new_administrator_session_path
    end
  end

  def sign_out_disabled_users
    if current_administrator.published == false
      sign_out(current_administrator)
      flash[:alert] = "Votre compte a été désactivé. Veuillez contacter l'administrateur."

      redirect_to new_administrator_session_path
    end
  end

  def place_bet_with_cancellation(bet, game_account_token, paymoney_account_number, password, transaction_amount)
    paymoney_account_token = check_account_number(paymoney_account_number)

    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    transaction_amount = transaction_amount.to_f.abs
    status = false

    if transaction_amount == 0
     @error_code = '5000'
     @error_description = "Le montant de transaction ne peut pas être nul."
    else
      if paymoney_account_token.blank? || paymoney_account_token == 'null'
        @error_code = '5001'
        @error_description = "Le numéro PAYMONEY est inexistant. Veuillez créer un compte puis réessayez."
      else
        request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/86d138798bc43ed59e5207c684564/bet/get/#{bet.transaction_id}/#{game_account_token}/#{paymoney_account_token}/#{password}/#{transaction_amount}", followlocation: true, method: :get, timeout: 30)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              bet.update_attributes(paymoney_transaction_id: response_body, bet_placed: true, bet_placed_at: DateTime.now, paymoney_account_token: paymoney_account_token)
              status = true
            else
              case response_body
                when "|0|"
                  @error_code = '4001'
                  @error_description = "Le numéro PAYMONEY est inexistant. Veuillez créer un compte puis réessayez."
                when "|3|"
                  @error_code = '4002'
                  @error_description = "Veuillez vérifier vos informations de paiement. Numéro de compte PAYMONEY et code secret."
                when "|4|"
                  @error_code = '4003'
                  @error_description = "Votre solde disponible sur le compte PAYMONEY est insuffisant. Veuillez recharger votre compte dans un point de rechargement. Merci!"
                else
                  @error_code = '4004'
                  @error_description = "Veuillez vérifier vos informations de paiement. Numéro de compte PAYMONEY et code secret."
                end

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
      if paymoney_account_token.blank? || paymoney_account_token == 'null'
        @error_code = '5001'
        @error_description = "Le numéro PAYMONEY est inexistant. Veuillez créer un compte puis réessayez."
      else
        body = "#{paymoney_wallet_url}/api/86d138798bc43ed59e5207c684564/bet/get/#{bet.sale_client_id}/#{game_account_token}/#{paymoney_account_token}/#{password}/#{transaction_amount}"
        request = Typhoeus::Request.new(body, followlocation: true, method: :get, timeout: 30)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              bet.update_attributes(p_payment_transaction_id: response_body, p_payment_request: body, paymoney_account_token: paymoney_account_token, p_payment_response: response_body)
              status = true
            else
              case response_body
                when "|0|"
                  @error_code = '4001'
                  @error_description = "Le numéro PAYMONEY est inexistant. Veuillez créer un compte puis réessayez."
                when "|3|"
                  @error_code = '4002'
                  @error_description = "Veuillez vérifier vos informations de paiement. Numéro de compte PAYMONEY et code secret."
                when "|4|"
                  @error_code = '4003'
                  @error_description = "Votre solde disponible sur le compte PAYMONEY est insuffisant. Veuillez recharger votre compte dans un point de rechargement. Merci!"
                else
                  @error_code = '4004'
                  @error_description = "Veuillez vérifier vos informations de paiement. Numéro de compte PAYMONEY et code secret."
                end
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
      if paymoney_account_token.blank? || paymoney_account_token == 'null'
        @error_code = '5001'
        @error_description = "Le numéro PAYMONEY est inexistant. Veuillez créer un compte puis réessayez."
      else
        @url = "#{paymoney_wallet_url}/api/9b04e57f135f05bc05b5cf6d9b0d8/bet/get/#{bet.transaction_id}/#{game_account_token}/#{paymoney_account_token}/#{password}/#{transaction_amount}"

        LogRequests.create(description: "Placement de pari sans annulation", request: @url)

        request = Typhoeus::Request.new(@url, followlocation: true, method: :get, timeout: 30)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              bet.update_attributes(paymoney_transaction_id: response_body, bet_placed: true, bet_placed_at: DateTime.now, paymoney_account_token: paymoney_account_token)
              status = true
            else
              case response_body
                when "|0|"
                  @error_code = '4001'
                  @error_description = "Le numéro PAYMONEY est inexistant. Veuillez créer un compte puis réessayez."
                when "|3|"
                  @error_code = '4002'
                  @error_description = "Veuillez vérifier vos informations de paiement. Numéro de compte PAYMONEY et code secret."
                when "|4|"
                  @error_code = '4003'
                  @error_description = "Votre solde disponible sur le compte PAYMONEY est insuffisant. Veuillez recharger votre compte dans un point de rechargement. Merci!"
                else
                  @error_code = '4004'
                  @error_description = "Veuillez vérifier vos informations de paiement. Numéro de compte PAYMONEY et code secret."
                end

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

    @url = "#{paymoney_wallet_url}/api/06331525768e6a95680c8bb0dcf55/bet/validate/#{game_account_token}/#{transaction_amount}"
    LogRequests.create(description: "Validation de pari", request: @url)

    request = Typhoeus::Request.new(@url, followlocation: true, method: :get)

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

    @url = "#{paymoney_wallet_url}/api/06331525768e6a95680c8bb0dcf55/bet/validate/#{game_account_token}/#{transaction_amount}"

    LogRequests.create(description: "Validation de pari AIL", request: @url)

    request = Typhoeus::Request.new(@url, followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          ActiveRecord::Base.connection.execute("UPDATE #{ail_object} SET paymoney_validation_id = '#{response_body}', bet_validated = TRUE, bet_validated_at = '#{DateTime.now}' WHERE game_account_token = '#{game_account_token}' AND draw_id = '#{@draw_id}' AND bet_validated IS NULL")
          #bet.update_attributes(paymoney_transaction_id: response_body, bet_placed: true, bet_placed_at: DateTime.now)
          status = true
        else
          @error_code = '5000'
          ActiveRecord::Base.connection.execute("UPDATE #{ail_object} SET error_code = '#{@error_code}', error_description = '#{response_body}' WHERE game_account_token = '#{game_account_token}' AND draw_id = '#{@draw_id}' AND bet_validated IS NULL")
          #bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
        end
      else
        @error_code = '4000'
        @error_description = 'Cannot join paymoney wallet server.'
        ActiveRecord::Base.connection.execute("UPDATE #{ail_object} SET error_code = '#{@error_code}', error_description = '#{@error_description}' WHERE game_account_token = '#{game_account_token}' AND draw_id = '#{@draw_id}' AND bet_validated IS NULL")
      end
    end

    request.run

    return status
  end

  def validate_bet_ail2(game_account_token, transaction_amount, ail_object, bet)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false

    @url = "#{paymoney_wallet_url}/api/06331525768e6a95680c8bb0dcf55/bet/validate/#{game_account_token}/#{transaction_amount}"

    LogRequests.create(description: "Validation de pari AIL", request: @url)

    request = Typhoeus::Request.new(@url, followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          #bet.update_attributes(paymoney_transaction_id: response_body, bet_placed: true, bet_placed_at: DateTime.now)
          status = true
        else
          @error_code = '5000'
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

  def validate_bet_cm3(game_account_token, transaction_amount, program_id, race_id)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false

    request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/06331525768e6a95680c8bb0dcf55/bet/validate/#{game_account_token}/#{transaction_amount}", followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          ActiveRecord::Base.connection.execute("UPDATE cms SET p_validation_id = '#{response_body}', p_validated = TRUE, p_validated_at = '#{DateTime.now}' WHERE program_id = '#{program_id}' AND race_id = '#{race_id}' AND p_validated IS NULL")
          #bet.update_attributes(paymoney_transaction_id: response_body, bet_placed: true, bet_placed_at: DateTime.now)
          status = true
        else
          @error_code = '5000'
          ActiveRecord::Base.connection.execute("UPDATE cms SET p_validation_response = '#{response_body}' WHERE race_id = '#{race_id}' AND p_validated IS NULL")
          #bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
        end
      else
        @error_code = '4000'
        @error_description = "Le serveur de paiement n'est pas accessible."
        ActiveRecord::Base.connection.execute("UPDATE cms SET p_validation_response = '#{response_body}' WHERE race_id = '#{race_id}' AND p_validated IS NULL")
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
          @error_description = "Le pari n'a pas pu être annulé."
          bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
        end
      else
        @error_code = '4000'
        @error_description = "Le serveur de paiement n'est pas accessible."
        bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
      end
    end

    request.run

    return status
  end

  def payback_unplaced_bet(bet)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false

    request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/35959d477b5ffc06dc673befbe5b4/bet/payback/#{bet.transaction_id}", followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          bet.update_attributes(payback_unplaced_bet_request: request_body, payback_unplaced_bet_response: response_body, payback_unplaced_bet: true, payback_unplaced_bet_at: DateTime.now)
          status = true
        else
          @error_code = '4001'
          @error_description = "Le pari n'a pas pu être annulé."
          bet.update_attributes(payback_unplaced_bet_request: request_body, payback_unplaced_bet_response: response_body, error_code: @error_code, error_description: @error_description)
        end
      else
        @error_code = '4000'
        @error_description = "Le serveur de paiement n'est pas accessible."
        bet.update_attributes(payback_unplaced_bet_request: request_body, error_code: @error_code, error_description: @error_description, response_body: response_body)
      end
    end

    request.run

    return status
  end

  def cancel_cm3_bet(bet)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false
    request_body = "#{paymoney_wallet_url}/api/35959d477b5ffc06dc673befbe5b4/bet/payback/#{bet.sale_client_id}"

    request = Typhoeus::Request.new(request_body, followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          bet.update_attributes(cancel_request: request_body, p_cancellation_id: response_body, cancelled: true, cancelled_at: DateTime.now, bet_status: "Annulé")
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

  def payback_unplaced_bet_cm3(bet)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false
    request_body = "#{paymoney_wallet_url}/api/35959d477b5ffc06dc673befbe5b4/bet/payback/#{bet.sale_client_id}"

    request = Typhoeus::Request.new(request_body, followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          bet.update_attributes(payback_unplaced_bet_request: request_body, payback_unplaced_bet_response: response_body, payback_unplaced_bet: true, payback_unplaced_bet_at: DateTime.now)
          status = true
        else
          @error_code = '4001'
          @error_description = "Erreur de paiement, le pari n'a pas pu être annulé."
          bet.update_attributes(payback_unplaced_bet_request: request_body, payback_unplaced_bet_response: response_body)
        end
      else
        @error_code = '4000'
        @error_description = 'Le serveur de paiement est indisponible.'
        bet.update_attributes(payback_unplaced_bet_request: request_body)
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
          bet.update_attributes(paymoney_earning_id: response_body, :"#{payment_type}_paid" => true, :"#{payment_type}_paid_at" => DateTime.now, bet_status: (payment_type == "earning" ? "Gagnant" : "Remboursé"))
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

  def pay_cm3_earnings(bet, game_account_token, transaction_amount)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false

    url = "#{paymoney_wallet_url}/api/86d1798bc43ed59e5207c68e864564/earnings/pay/#{game_account_token}/#{bet.paymoney_account_token}/#{bet.sale_client_id}/#{transaction_amount}"

    request = Typhoeus::Request.new(url, followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        response_body = response.body

        if !response_body.include?("|")
          bet.update_attributes(p_earning_id: response_body, pay_earning_request: url, bet_status: "Gagnant", p_validated: true)
          status = true
        else
          @error_code = '4001'
          @error_description = 'Erreur de paiement.'
          bet.update_attributes(win_request: url, win_response: response_body)
        end
      else
        @error_code = '4000'
        @error_description = "Le serveur de paiement n'est pas disponible."
        bet.update_attributes(win_request: url)
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
    @user = User.find_by_uuid(bet.gamer_id) rescue nil
    if @user.blank?
      @user = User.find_by_uuid(bet.punter_id)
    end
    @msisdn = @user.msisdn rescue ""
    if amount.to_f > @sill_amount
      @message_content = %Q[
        Vous avez gagné #{amount} F en jouant #{game} sur PARIONS DIRECT.
        Num ticket: #{ticket_number} #{bet.class.to_s == "Cm" ? "Réf: N" + bet.race_id[-1..-1] : ""}. RDV au siège LONACI pour votre gain. CLIQUE-PARIE & GAGNE.]
    else
      @message_content = %Q[
        Vous avez gagné #{amount} F en jouant #{game} sur PARIONS DIRECT.
        Num ticket: #{ticket_number} #{bet.class.to_s == "Cm" ? "Réf: N" + bet.race_id[-1..-1] : ""}. Votre compte PAYMONEY: #{bet.paymoney_account_number} vient d'être rechargé. CONTINUEZ DE JOUER ET GAGNEZ DIRECT.]
    end
  end

  def build_ail_message(bet, amount, game, ticket_number, ref_number)
    @user = User.find_by_uuid(bet.gamer_id)
    @msisdn = @user.msisdn rescue ""
    if amount.to_f > @sill_amount
      @message_content = %Q[
        Vous avez gagné #{amount} F en jouant #{game} sur PARIONS DIRECT.
        Num ticket: #{ticket_number} Numéro de Ref.: #{ref_number} Reunion: #{bet.selector1} Course: #{bet.selector2}. RDV au siège LONACI pour votre gain. CLIQUE-PARIE & GAGNE.]
    else
      @message_content = %Q[
        Vous avez gagné #{amount} F en jouant #{game} sur PARIONS DIRECT.
        Num ticket: #{ticket_number} Numéro de Ref.: #{ref_number} Reunion: #{bet.selector1} Course: #{bet.selector2}. Votre compte PAYMONEY: #{bet.paymoney_account_number} vient d'être rechargé. CONTINUEZ DE JOUER ET GAGNEZ DIRECT.]
    end
  end

  # Check if the parameter is not a number
  def not_a_number?(n)
  	n.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? true : false
  end

  # Check if the parameter is not a number
  def is_a_number?(n)
  	n.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  def set_pos_operation_token(certified_agent_id, operation_type)
    @token = ""
    # Wari
    if certified_agent_id == "af478a2c47d8418a"
      case operation_type
      when "cash_in"
        @token = "9cff7473"
      when "cash_out"
        @token = "3392eecd"
      when "ascent"
        @token = "573504f7"
      end
    end
    # Qash
    if certified_agent_id == "684239a94ca63639"
      case operation_type
      when "cash_in"
        @token = "1f039cd8"
      when "cash_out"
        @token = "b87b6c80"
      when "ascent"
        @token = "2396b109"
      end
    end
    # VITFE
    if certified_agent_id == "374c75e1ff2623ca"
      case operation_type
      when "cash_in"
        @token = "C64E76BD"
      when "cash_out"
        @token = "A57EB4B0"
      when "ascent"
        @token = "5B511D84"
      end
    end
    # Smart Fidelis
    if certified_agent_id == "99999999"
      @has_rib = (RestClient.get "http://pay-money.net/pos/has_rib/#{@certified_agent_id}" rescue "")
      @has_rib.to_s == "0" ? @has_rib = false : @has_rib = true

      print "*****************" + @has_rib.to_s + "*****************"

      if operation_type == "cash_in"
        if @has_rib
          @token = "5a518a5a"
        else
          @token = "6d6dde69"
        end
      end
      if operation_type == "cash_out"
        if @has_rib
          @token = "2968e7b4"
        else
          @token = "9a28edf0"
        end
      end
      if operation_type == "ascent"
        if @has_rib
          @token = "13a3fd04"
        else
          @token = "e3875eab"
        end
      end
    end
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname, :lastname, :phone_number, :email, :password, :password_confirmation) }

      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:firstname, :lastname, :phone_number, :password, :password_confirmation, :current_password) }
    end
end
