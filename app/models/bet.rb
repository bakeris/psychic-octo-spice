class Bet < ActiveRecord::Base
  # Accessible fields
  attr_accessible :license_code, :pos_code, :terminal_id, :account_id, :account_type, :transaction_id, :amount, :win_amount, :validated, :validated_at, :ticket_id, :ticket_timestamp, :transaction_id, :cancelled, :cancelled_at, :cancellation_timestamp, :remote_ip_address, :pn_ticket_status, :pn_amount_win, :pn_timestamp, :pn_transaction_id, :pn_event_ticket_status, :pn_type_result, :pn_winning_value, :pn_winning_position, :pr_transaction_id, :pr_status, :payment_status_datetime, :user_id, :gamer_id, :earning_paid, :earning_paid_at, :cancellation_paymoney_id, :payment_paymoney_id, :game_account_token, :paymoney_account_token, :error_code, :error_description, :sms_sent, :sms_content, :message_id, :sms_status, :sms_id, :begin_date, :end_date, :formula, :bet_status, :paymoney_account_number, :on_hold_winner_paid_at, :payback_unplaced_bet_request, :payback_unplaced_bet_response, :payback_unplaced_bet, :payback_unplaced_bet_at, :system_code, :number_of_combinations, :created_at

  # Relationships
  has_many :bet_coupons
  belongs_to :user

  def self.to_csv
    attributes = %w{Id-de-transaction Statut-du-ticket Date-de-prise-du-pari Formule-du-pari Numero-de-ticket Montant-du-ticket Montant-du-gain Code-parieur Nom-parieur Email-parieur Telephone-parieur Compte-paymoney}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |spc_bet|
        @user = User.find_by_uuid(spc_bet.gamer_id)
        csv << [spc_bet.transaction_id, spc_bet.bet_status, spc_bet.validated_at, spc_bet.formula, spc_bet.ticket_id, spc_bet.amount, spc_bet.win_amount, spc_bet.gamer_id, (@user.full_name rescue ''), (@user.email rescue ''), (@user.msisdn rescue ''), spc_bet.paymoney_account_number]
      end
    end
  end
end
