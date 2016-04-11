class EpplController < ApplicationController
# Chargement du sous compte eppl - prise de paris. debit du compte paymoney, crédit du compte d'attente
# Jouer eppl - vrai prise de paris eppl validée toutes les 17 min
# Transfert de gains - paiement de gains eppl, du compte eppl vers son compte paymoney
# Transfert de gains - rejouer à eppl compte TRJ, prise de paris TRJ débité pour créditer le compte eppl


  def charge_eppl_account
    @transaction_amount = params[:transaction_amount]
    @gamer_id = params[:gamer_id]
    set_place_bet_params(@gamer_id, @transaction_amount)

    if @user.blank?
      @error_code = '3000'
      @error_description = "L'identifiant du parieur n'a pas été trouvé."
    else
      charge_eppl(@game_account_token, params[:paymoney_account_number], params[:password], @transaction_amount)
    end
  end

  def charge_eppl(game_account_token, paymoney_account_number, password, transaction_amount)
    paymoney_account_token = check_account_number(paymoney_account_number)
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]

    paymoney_wallet_url = Parameters.first.paymoney_wallet_url rescue ""
    transaction_amount = transaction_amount.to_f.abs

    if transaction_amount == 0
     @error_code = '5000'
     @error_description = "Le montant de transaction ne peut pas être nul."
    else
      if paymoney_account_token.blank?
        @error_code = '5001'
        @error_description = "Le compte Paymoney n'a pas été trouvé."
      else
        @url = "#{paymoney_wallet_url}/api/86d138798bc43ed59e5207c684564/bet/get/#{transaction_id}/#{game_account_token}/#{paymoney_account_token}/#{password}/#{transaction_amount}"

        LogRequests.create(description: "Chargement de compte Eppl", request: @url)

        request = Typhoeus::Request.new(@url, followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              @transaction_id = response_body
              Eppl.create(operation: "Chargement de compte", transaction_id: @transaction_id, paymoney_account_number: paymoney_account_number, transaction_amount: transaction_amount, game_account_token: game_account_token, bet_placed_at: DateTime.now, gamer_id: @gamer_id) rescue nil
            else
              case response_body
                when "|0|"
                  @error_code = '4001'
                  @error_description = "Le compte Paymoney n'existe pas."
                when "|3|"
                  @error_code = '4002'
                  @error_description = "La transaction a échoué."
                when "|4|"
                  @error_code = '4003'
                  @error_description = "Votre solde disponible sur le compte PAYMONEY est insuffisant. Veuillez recharger votre compte dans un point de rechargement. Merci!"
                else
                  @error_code = '4004'
                  @error_description = "Une erreur s'est produite, veuillez réessayer."
                end
            end
          else
            @error_code = '4000'
            @error_description = 'Le serveur de paiement est inaccessible.'
          end
        end

        request.run
      end
    end
  end

  def api_place_bet
    @error_code = ""
    @error_description = ""
    @remote_ip = request.remote_ip
    #@user = User.find_by_uuid(gamer_id)
    @transaction_amount = params[:transaction_amount]
    # TRJ account
    @game_account_token = "PExxGeLY"

    begin_date = params[:begin_date]
    end_date = params[:end_date]

    #if @user.blank?
      #@error_code = '3000'
      #@error_description = "L'identifiant du parieur n'a pas été trouvé."
    #else
      @eppl = Eppl.create(operation: "Prise de pari", transaction_id: Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s, paymoney_account_number: params[:paymoney_account_number], transaction_amount: @transaction_amount, remote_ip: @remote_ip, game_id: params[:game_id], game_account_token: @game_account_token, begin_date: begin_date, bet_placed: true, bet_placed_at: DateTime.now, paymoney_transaction_id: Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s)

      #if !place_bet_with_cancellation(@eppl, @game_account_token, params[:paymoney_account_number], params[:password], @transaction_amount)
        #@eppl.update_attributes(error_code: @error_code, error_description: @error_description)
      #end
    #end
  end

  def periodically_validate_bet
    @unvalidated_bets = Eppl.where("bet_validated IS NULL")

    unless @unvalidated_bets.blank?
      bets_amount = @unvalidated_bets.map{|bet| (bet.transaction_amount.to_f rescue 0)}.sum rescue 0
      validate_bet("PExxGeLY", bets_amount)
    end

    #render nothing: true
  end

  def set_place_bet_params(gamer_id, transaction_amount)
    @error_code = ""
    @error_description = ""
    @remote_ip = request.remote_ip
    @user = User.find_by_uuid(gamer_id)
    @transaction_amount = transaction_amount.to_f.abs
    # TRJ account
    @game_account_token = "PExxGeLY"
  end

  def api_pay_earning
    @eppl = (Eppl.where(transaction_id: params[:transaction_id], bet_placed: true).first rescue nil)
    paymoney_wallet_url = Parameters.first.paymoney_wallet_url rescue ""

    if @eppl.blank?
      @error_code = '4000'
      @error_description = "The transaction can't be found."
    else
      if @eppl.earning_transaction_id.blank?
        request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/86d1798bc43ed59e5207c68e864564/earnings/pay/LVNbmiDN/#{@eppl.paymoney_account_token}/#{params[:transaction_id]}/#{@eppl.transaction_amount}", followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              @eppl.update_attributes(earning_transaction_id: response_body, earning_paid: true, earning_paid_at: DateTime.now)
              @error_code = ""
              @error_description = ""
            else
              @error_code = '4001'
              @error_description = 'Payment error, could not checkout the account. Check the credit.'
              @eppl.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
            end
          else
            @error_code = '4000'
            @error_description = 'Cannot join paymoney wallet server.'
            @eppl.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
          end
        end

        request.run
      else
        @error_code = '4002'
        @error_description = "Cette transaction a déjà été payée."
      end
    end
  end

  def api_transfer_earning
    #@eppl = (Eppl.where(transaction_id: params[:transaction_id], bet_placed: true).first rescue nil)
    paymoney_wallet_url = Parameters.first.paymoney_wallet_url rescue ""
    paymoney_account_number = params[:paymoney_account_number]
    paymoney_account_token = check_account_number(params[:paymoney_account_number])
    transaction_amount = params[:transaction_amount]

    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]

    if paymoney_account_token.blank?
      @error_code = '4000'
      @error_description = "Le compte Paymoney n'a pas été trouvé."
    else
      #if @eppl.earning_transaction_id.blank?
        @url = "#{paymoney_wallet_url}/api/86d1798bc43ed59e5207c68e864564/earnings/pay/PExxGeLY/#{paymoney_account_token}/#{transaction_id}/#{transaction_amount}"
        LogRequests.create(description: "Transfert de gains EPPL", request: @url)

        request = Typhoeus::Request.new(@url, followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              Eppl.create(operation: "Transfert de gains", transaction_id: response_body, paymoney_account_number: paymoney_account_number, transaction_amount: transaction_amount, game_account_token: "PExxGeLY", bet_placed_at: DateTime.now) rescue nil
              @response_body = response_body
              @error_code = ""
              @error_description = ""
            else
              @error_code = '4001'
              @error_description = "Erreur de paiement, le paiement n'a pas pu être effectué."
              #@eppl.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
            end
          else
            @error_code = '4000'
            @error_description = "Le serveur Paymoney n'est pas accessible."
            #@eppl.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
          end
        end

        request.run
      #else
        #@error_code = '4002'
        #@error_description = "Cette transaction a déjà été payée."
      #end
    end
  end

  def api_recharge_eppl_account
    #@eppl = (Eppl.where(transaction_id: params[:transaction_id], bet_placed: true).first rescue nil)
    paymoney_wallet_url = Parameters.first.paymoney_wallet_url rescue ""
    @transaction_amount = params[:transaction_amount]

    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]

      #if @eppl.earning_transaction_id.blank?
        @url = "#{paymoney_wallet_url}/api/86d138798bc43ed59e5207c684564/bet/get/#{transaction_id}/PExxGeLY/TRJ/TRJ_pass/#{@transaction_amount}"
        LogRequests.create(description: "Rechargement de compte EPPL", request: @url)

        request = Typhoeus::Request.new(@url, followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              #@eppl.update_attributes(earning_transaction_id: response_body, earning_paid: true, earning_paid_at: DateTime.now)
              @response_body = response_body
              @error_code = ""
              @error_description = ""

              Eppl.create(operation: "Rechargement de compte", transaction_id: response_body, paymoney_account_number: "TRJ", transaction_amount: @transaction_amount, game_account_token: "PExxGeLY", bet_placed_at: DateTime.now, gamer_id: @gamer_id) rescue nil
            else
              case response_body
                when "|0|"
                  @error_code = '4001'
                  @error_description = "Le compte Paymoney n'existe pas."
                when "|3|"
                  @error_code = '4002'
                  @error_description = "La transaction a échoué."
                when "|4|"
                  @error_code = '4003'
                  @error_description = "Votre solde disponible sur le compte PAYMONEY est insuffisant. Veuillez recharger votre compte dans un point de rechargement. Merci!"
                else
                  @error_code = '4004'
                  @error_description = "Une erreur s'est produite, veuillez réessayer."
                end
              #@eppl.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
            end
          else
            @error_code = '4000'
            @error_description = "Le serveur Paymoney n'est pas accessible."
            #@eppl.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
          end
        end

        request.run
      #else
        #@error_code = '4002'
        #@error_description = "Cette transaction a déjà été payée."
      #end
  end

end
