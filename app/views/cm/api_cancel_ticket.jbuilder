if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.bet do
    json.program_id @bet.program_id
    json.race_id @bet.race_id
    json.scratched_list @bet.scratched_list
    json.sale_client_id @bet.sale_client_id
    json.wagers do
      @bet.cm_wagers.each do |wager|
        json.bet_id wager.bet_id rescue ""
        json.nb_units wager.nb_units rescue ""
        json.nb_combinations wager.nb_combinations rescue ""
        json.full_box wager.full_box rescue ""
        json.selections wager.selections_sting rescue ""
      end
    end
    json.gamer_id @bet.punter_id
    json.amount @bet.amount
    json.serial_number @bet.serial_number
    json.bet_placed (@bet.p_payment_transaction_id.blank? ? false.to_s : true.to_s)
    json.bet_placed_at @bet.bet_placed_at.to_s
    json.paymoney_account_number @bet.paymoney_account_number
    json.bet_cancelled @bet.cancelled.to_s
    json.bet_cancelled_at @bet.cancelled_at.to_s
  end
end
