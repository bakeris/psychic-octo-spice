class EpplController < ApplicationController

  def api_place_bet
    paymoney_account_token = check_account_number(params[:paymoney_account_number])
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")
    transaction_amount = params[:transaction_amount].to_f.abs
    password = params[:password]
    gamer_id = params[:gamer_id]
    remote_ip = request.remote_ip

    if transaction_amount == 0
     @error_code = '5000'
     @error_description = "The transaction amount can't be 0."
    else
      if paymoney_account_token.blank?
        @error_code = '5001'
        @error_description = "The paymoney account have not been found."
      else
        @eppl = Eppl.create(transaction_id: Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s, paymoney_account: params[:paymoney_account_number], transaction_amount: transaction_amount, remote_ip: remote_ip, paymoney_account_token: paymoney_account_token, gamer_id: gamer_id, game_account_token: "PExxGeLY")
        request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/86d138798bc43ed59e5207c684564/bet/get/PExxGeLY/#{paymoney_account_token}/#{password}/#{transaction_amount}", followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            response_body = response.body

            if !response_body.include?("|")
              @eppl.update_attributes(paymoney_transaction_id: response_body, bet_placed: true, bet_placed_at: DateTime.now)
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
      end
    end
  end

  def api_pay_earning
    @eppl = (Eppl.where(transaction_id: params[:transaction_id], bet_placed: true).first rescue nil)

    if @eppl.blank?
      @error_code = '4000'
      @error_description = "The transaction can't be found."
    else
      request = Typhoeus::Request.new("#{paymoney_wallet_url}/api/86d1798bc43ed59e5207c68e864564/earnings/pay/LVNbmiDN/#{@eppl.paymoney_account_token}/#{@eppl.transaction_amount}", followlocation: true, method: :get)

      request.on_complete do |response|
        if response.success?
          response_body = response.body

          if !response_body.include?("|")
            @eppl.update_attributes(earning_transaction_id: response_body, earning_paid: true, earning_paid_at: DateTime.now)
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
    end
  end

end
