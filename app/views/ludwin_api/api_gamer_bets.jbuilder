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
    json.created_at b(bet.created_at.strftime("%d-%m-%Y") + " " + bet.created_at.strftime("%Hh %Mmn")) rescue nil
    json.bet_placed bet.bet_placed rescue nil
    json.bet_placed_at (bet.validated_at.strftime("%d-%m-%Y") + " " + bet.validated_at.strftime("%Hh %Mmn")) rescue nil

    json.paymoney_account_token bet.paymoney_account_token rescue nil
    json.bet_cancelled bet.bet_cancelled rescue nil
    json.bet_cancelled_at bet.bet_cancelled_at rescue nil
    coupons = bet.bet_coupons
    unless coupons.blank?
      json.coupons coupons do |coupon|
        json.bet_id coupon.bet_id
        json.pal_code coupon.pal_code
        json.event_code coupon.event_code
        json.bet_code coupon.bet_code
        json.draw_code coupon.draw_code
        json.odd coupon.odd
        json.begin_date coupon.begin_date
        json.teams coupon.teams
        json.sport coupon.sport
      end
    end
    json.formula bet.formula rescue nil
    json.bet_status bet.bet_status rescue nil
  end
end
