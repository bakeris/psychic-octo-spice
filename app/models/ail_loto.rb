class AilLoto < ActiveRecord::Base
  # Accessible fields
  attr_accessible :operation, :transaction_id, :message_id, :confirm_id, :date_time, :bet_code, :bet_modifier, :selector1, :selector2, :repeats, :special_count, :normal_count, :entries, :special_entries, :normal_entries, :response_status, :response_date_time, :response_data_name, :response_error_code, :response_error_message, :ticket_number, :ref_number, :audit_number, :bet_cost_amount, :bet_payout_amount, :response_bet_code, :response_bet_modifier, :response_selector1, :response_selector2, :response_repeats, :response_special_entries, :response_normal_entries, :refund_acknowledge, :refund_acknowledge_date_time, :cancellation_acknowledge, :cancellation_acknowledge_date_time, :placement_acknowledge, :placement_acknowledge_date_time, :remote_ip_address, :gamer_id, :paymoney_account_number, :paymoney_transaction_id, :bet_placed, :bet_placed_at, :bet_cancelled, :bet_cancelled_at, :error_description, :response_body, :user_id, :earning_paid, :earning_paid_at, :cancellation_paymoney_id, :payment_paymoney_id, :draw_id, :game_account_token, :paymoney_validation_id, :paymoney_account_token, :earning_amount, :refund_amount, :refund_paid, :refund_amount_at, :paymoney_earning_id, :paymoney_refund_id, :bet_validated, :bet_validated_at, :earning_notification_received, :earning_notification_received_at, :refund_notification_received, :refund_notification_received_at, :sms_sent, :sms_content, :message_id, :sms_status, :sms_id, :error_code, :race_id, :begin_date, :end_date, :draw_day, :draw_number, :bet_status, :basis_amount, :bet_date, :on_hold_winner_paid_at, :created_at

  # Relationships
  belongs_to :user

  def loto_code
    bet_type = LotoBetType.where(code: bet_code, category: bet_modifier)
    return bet_type.first.description rescue ""
  end

  def self.to_csv
    attributes = %w{Id-de-transaction Statut-du-ticket Date-de-prise-du-pari Formule-du-pari Code-du-pari Type-de-pari Selecteur1 Selecteur2 Repeats Special-count Normal-count Entrees Entrees-normales Entrees-speciales Mise-de-base Numero-de-ticket Reference-du-ticket Montant-du-ticket Montant-du-gain Montant-du-remboursement Code-parieur Nom-parieur Email-parieur Telephone-parieur Compte-paymoney}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |loto_bet|
        @user = User.find_by_uuid(loto_bet.gamer_id)
        csv << [loto_bet.transaction_id, loto_bet.bet_status, loto_bet.bet_date, loto_bet.loto_code, loto_bet.bet_code, loto_bet.bet_modifier, loto_bet.selector1, loto_bet.selector2, loto_bet.repeats, loto_bet.special_count, loto_bet.normal_count, loto_bet.entries, loto_bet.normal_entries, loto_bet.special_entries, loto_bet.basis_amount, loto_bet.ticket_number, loto_bet.ref_number, loto_bet.bet_cost_amount, loto_bet.earning_amount, loto_bet.refund_amount, loto_bet.gamer_id, (@user.full_name rescue ''), (@user.email rescue ''), (@user.msisdn rescue ''), loto_bet.paymoney_account_number]
      end
    end
  end

end
