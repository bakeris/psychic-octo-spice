if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.bets @bets do |bet|
    json.program_id bet.program_id rescue nil
    json.race_id bet.race_id rescue nil
    json.transaction_id bet.sale_client_id rescue nil
    json.serial_number bet.serial_number rescue nil
    json.amount bet.amount rescue nil
    json.scratched_list bet.scratched_list rescue nil
    json.bet_placed_at (bet.bet_placed_at.strftime("%d-%m-%Y") + " " + bet.bet_placed_at.strftime("%Hh %Mmn")) rescue nil
    json.scratched_list bet.scratched_list rescue nil
    json.cancelled bet.cancelled rescue nil
    json.cancelled_at bet.cancelled_at rescue nil
    json.win_amount bet.win_amount rescue nil
    json.payment_validated bet.p_validated rescue nil
    json.payment_validated_at bet.p_validated rescue nil
    json.paid (bet.p_earning_id.blank? ? false : true)
    json.refunded (bet.p_refund_id.blank? ? false : true)
    json.begin_date bet.begin_date rescue nil
    json.end_date bet.end_date rescue nil
    json.bet_status bet.bet_status rescue nil
    wagers = bet.cm_wagers
    unless wagers.blank?
      json.wagers wagers do |wager|
        json.bet_id wager.bet_id
        json.nb_units wager.nb_units
        json.nb_combinations wager.nb_combinations
        json.full_box wager.full_box
        json.selections_string wager.selections_string
        json.winner wager.winner
      end
    end
  end
end
