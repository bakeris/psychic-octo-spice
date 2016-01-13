class EpplController < ApplicationController

  def api_place_bet
    set_place_bet_params(params[:gamer_id], params[:transaction_amount])
    begin_date = params[:begin_date]
    end_date = params[:end_date]

    if @user.blank?
      @error_code = '3000'
      @error_description = "L'identifiant du parieur n'a pas été trouvé."
    else
      @eppl = Eppl.create(transaction_id: Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s, paymoney_account: params[:paymoney_account_number], transaction_amount: @transaction_amount, remote_ip: @remote_ip, gamer_id: params[:gamer_id], game_account_token: @game_account_token, begin_date: begin_date, end_date: end_date)

      if !place_bet_with_cancellation(@eppl, @game_account_token, params[:paymoney_account_number], params[:password], @transaction_amount)
        @eppl.update_attributes(error_code: @error_code, error_description: @error_description)
      end
    end
  end

  def periodically_validate_bet
    @unvalidated_bets = Eppl.where("bet_validated IS NULL")

    unless @unvalidated_bets.blank?
      bets_amount = @unvalidated_bets.map{|bet| (bet.transaction_amount.to_f rescue 0)}.sum rescue 0
      validate_bet("uXAXMDuW", bets_amount)
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
    @game_account_token = "c33fa532"
  end

  def api_pay_earning
    @eppl = (Eppl.where(transaction_id: params[:transaction_id], bet_placed: true).first rescue nil)
    paymoney_wallet_url = (Parameters.first.paymoney_wallet_url rescue "")

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

end
