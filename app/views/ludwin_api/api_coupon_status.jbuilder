if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.bet do
    json.transaction_id @bet.transaction_id
    json.pal_code @bet.bet_coupons.first.pal_code rescue ""
    json.event_code @bet.bet_coupons.first.event_code rescue ""
    json.bet_code @bet.bet_coupons.first.bet_code rescue ""
    json.draw_code @bet.bet_coupons.first.draw_code rescue ""
    json.odd @bet.bet_coupons.first.odd rescue ""
    json.amount @bet.amount
    json.win_amount @bet.win_amount
    json.placed @bet.validated ? "true" : "false"
    json.placed_at @bet.validated_at
    json.ticket_id @bet.ticket_id
    json.cancelled @bet.cancelled ? "true" : "false"
    json.cancelled_at @bet.cancelled_at
    json.paid @bet.pr_status ? "true" : "false"
    json.paid_at @bet.payment_status_datetime
    json.paymoney_earning_paid @bet.earning_paid ? "true" : "false"
    json.paymoney_payment_id @bet.payment_paymoney_id
    json.paymoney_earning_paid_at @bet.earning_paid_at
  end
end
