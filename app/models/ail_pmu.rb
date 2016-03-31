class AilPmu < ActiveRecord::Base
  # Accessible fields
  attr_accessible :operation, :transaction_id, :message_id, :confirm_id, :date_time, :bet_code, :bet_modifier, :selector1, :selector2, :repeats, :special_count, :normal_count, :entries, :special_entries, :normal_entries, :response_status, :response_date_time, :response_data_name, :response_error_code, :response_error_message, :ticket_number, :ref_number, :audit_number, :bet_cost_amount, :bet_payout_amount, :response_bet_code, :response_bet_modifier, :response_selector1, :response_selector2, :response_repeats, :response_special_entries, :response_normal_entries, :refund_acknowledge, :refund_acknowledge_date_time, :cancellation_acknowledge, :cancellation_acknowledge_date_time, :placement_acknowledge, :placement_acknowledge_date_time, :remote_ip_address, :gamer_id, :paymoney_account_number, :paymoney_transaction_id, :bet_placed, :bet_placed_at, :bet_cancelled, :bet_cancelled_at, :error_description, :response_body, :user_id, :earning_paid, :earning_paid_at, :cancellation_paymoney_id, :payment_paymoney_id, :race_id, :game_account_token, :paymoney_validation_id, :paymoney_account_token, :earning_amount, :refund_amount, :refund_paid, :refund_amount_at, :paymoney_earning_id, :paymoney_refund_id, :bet_validated, :bet_validated_at, :earning_notification_received, :earning_notification_received_at, :refund_notification_received, :refund_notification_received_at, :sms_sent, :sms_content, :message_id, :sms_status, :sms_id, :error_code, :race_id, :begin_date, :end_date, :starter_horses, :race_details, :bet_status, :draw_id, :bet_date, :on_hold_winner_paid_at

  # Relationships
  belongs_to :user

  def pmu_code
    bet_type = PmuBetType.where(code: bet_code, category: bet_modifier)
    return bet_type.first.description rescue ""
  end

  def self.to_csv
    attributes = %w{Id-de-transaction Statut-du-ticket Date-de-prise-du-pari Formule-du-pari Code-du-pari Type-de-pari Selecteur1 Selecteur2 Repeats Special-count Normal-count Entrees Entrees-normales Entrees-speciales Numero-de-ticket Reference-du-ticket Montant-du-ticket Montant-du-gain Montant-du-remboursement Code-parieur Nom-parieur Email-parieur Telephone-parieur Compte-paymoney}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |pmu_bet|
        @user = User.find_by_uuid(pmu_bet.gamer_id)
        csv << [pmu_bet.transaction_id, pmu_bet.bet_status, pmu_bet.bet_date, pmu_bet.pmu_code, pmu_bet.bet_code, pmu_bet.bet_modifier, pmu_bet.selector1, pmu_bet.selector2, pmu_bet.repeats, pmu_bet.special_count, pmu_bet.normal_count, pmu_bet.entries, pmu_bet.normal_entries, pmu_bet.special_entries, pmu_bet.ticket_number, pmu_bet.ref_number, pmu_bet.bet_cost_amount, pmu_bet.earning_amount, pmu_bet.refund_amount, pmu_bet.gamer_id, (@user.full_name rescue ''), (@user.email rescue ''), (@user.msisdn rescue ''), pmu_bet.paymoney_account_number]
      end
    end
  end
end
