if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.bets @bets do |bet|
    json.transaction_id bet.transaction_id rescue nil
    json.amount bet.amount rescue nil
    json.win_amount bet.win_amount rescue nil
    json.validated bet.validated rescue nil
    json.validated_at bet.validated_at rescue nil
    json.ticket_id bet.ticket_id rescue nil
    json.ticket_timestamp bet.ticket_timestamp rescue nil
    json.cancelled bet.cancelled rescue nil
    json.cancelled_at bet.cancelled_at rescue nil
    json.created_at bet.created_at rescue nil
    json.bet_placed bet.bet_placed rescue nil
    json.bet_placed_at bet.bet_placed_at rescue nil
    json.paymoney_account_token bet.paymoney_account_token rescue nil
    json.bet_cancelled bet.bet_cancelled rescue nil
    json.bet_cancelled_at bet.bet_cancelled_at rescue nil
    json.begin_date bet.begin_date recue nil
    json.end_date bet.end_date recue nil
  end
end
