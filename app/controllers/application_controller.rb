class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def place_bet(bet, game_account_token, paymoney_account_number, password, transaction_amount)
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
        request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/86d138798bc43ed59e5207c684564/bet/get/#{bet.transaction_id}/#{game_account_token}/#{paymoney_account_token}/#{password}/#{transaction_amount}", followlocation: true, method: :get)

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

  def validate_bet(transaction_id)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    status = false

    request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/06331525768e6a95680c8bb0dcf55/bet/validate/#{transaction_id}", followlocation: true, method: :get)

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

  def pay_earnings(bet, game_account_token, transaction_amount)
    paymoney_account_token = check_account_number(bet.paymoney_account_number)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
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
        request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/86d1798bc43ed59e5207c68e864564/earnings/pay/#{game_account_token}/#{paymoney_account_token}/#{transaction_amount}", followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              bet.update_attributes(payment_paymoney_id: response_body, earning_paid: true, earning_paid_at: DateTime.now)
              status = true
            else
              @error_code = '4001'
              @error_description = 'Payment error, could not checkout the account. Check the credit.'
              bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
            end
          else
            @error_code = '4000'
            @error_description = 'Cannot join paymoney wallet server.'
            bet.update_attributes(error_code: @error_code, error_description: @error_description, response_body: response_body)
          end
        end

        request.run
      end
    end

    return status
  end

  def check_account_number(account_number)
    print "fffffffffffffff" + account_number
    token = (RestClient.get "http://94.247.178.141:8080/PAYMONEY_WALLET/rest/check2_compte/#{account_number}" rescue "")
    print token

    return token
  end
end
