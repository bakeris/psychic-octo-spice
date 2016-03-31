class Cm < ActiveRecord::Base

  # Relationship
  has_many :cm_wagers

  # Accessible fields
  attr_accessible :connection_id, :program_id, :race_id, :sale_client_id, :punter_id, :amount, :scratched_list, :serial_number, :bet_placed_at, :placement_request, :placement_response, :game_account_token, :paymoney_account_number, :paymoney_account_token, :p_payment_transaction_id, :p_payment_request, :p_payment_response, :payment_error_code, :payment_error_description, :cancel_request, :cancel_response, :cancelled, :cancelled_at, :p_cancellation_id, :suid, :win_amount, :win_reason, :win_bet_ids, :win_checksum, :win_request, :win_response, :p_validation_request, :p_validation_response, :p_validation_id, :p_validated, :p_validated_at, :pay_earning_request, :pay_earning_response, :p_earning_id, :pay_refund_request, :pay_refund_response, :p_refund_id, :remote_ip, :transaction_id, :bet_identifier, :begin_date, :end_date, :bet_status, :sms_sent, :sms_content, :sms_status, :sms_id, :payback_unplaced_bet_request, :payback_unplaced_bet_response, :payback_unplaced_bet, :payback_unplaced_bet_at

  def self.to_csv
    attributes = %w{Id-de-transaction Statut-du-ticket Date-de-prise-du-pari ID-du-programme ID-de-la-course Non-partants Numero-de-ticket Montant-du-ticket Montant-du-gain Code-parieur Nom-parieur Email-parieur Telephone-parieur Compte-paymoney}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |cm_bet|
        @user = User.find_by_uuid(cm_bet.punter_id)
        csv << [cm_bet.sale_client_id, cm_bet.bet_status, cm_bet.bet_placed_at, cm_bet.program_id, cm_bet.race_id, cm_bet.scratched_list, cm_bet.serial_number, cm_bet.amount, cm_bet.win_amount, cm_bet.punter_id, (@user.full_name rescue ''), (@user.email rescue ''), (@user.msisdn rescue ''), cm_bet.paymoney_account_number]
      end
    end
  end

end
