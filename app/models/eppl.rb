class Eppl < ActiveRecord::Base
  # Accessible fields
  attr_accessible :transaction_id, :paymoney_account, :transaction_amount, :bet_placed, :bet_placed_at, :earning_paid, :earning_paid_at, :paymoney_transaction_id, :error_code, :error_description, :response_body, :remote_ip, :paymoney_account_token, :earning_transaction_id, :user_id, :gamer_id, :bet_placed, :bet_placed_at, :bet_cancelled, :bet_cancelled_at, :cancellation_paymoney_id, :payment_paymoney_id, :game_account_token, :bet_validated, :bet_validated_at, :paymoney_validation_id, :sms_sent, :sms_content, :message_id, :sms_status, :begin_date, :end_date, :game_id, :paymoney_account_number, :operation, :created_at

  # Relationships
  belongs_to :user

  def self.to_csv
    attributes = %w{Id-de-transaction Statut-de-la-transaction Date-de-la-transaction Montant-de-la-transaction Code-parieur Nom-parieur Email-parieur Telephone-parieur Compte-paymoney}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |eppl_bet|
        @user = User.find_by_uuid(eppl_bet.gamer_id)
        csv << [eppl_bet.transaction_id, (eppl_bet.bet_placed == true ? 'Validée' : 'Echouée'), eppl_bet.created_at, eppl_bet.transaction_amount, eppl_bet.gamer_id, (@user.full_name rescue ''), (@user.email rescue ''), (@user.msisdn rescue ''), eppl_bet.paymoney_account_number]
      end
    end
  end
end
