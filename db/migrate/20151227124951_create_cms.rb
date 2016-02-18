class CreateCms < ActiveRecord::Migration
  def change
    create_table :cms do |t|
      t.string :connection_id
      t.string :program_id
      t.string :race_id
      t.string :sale_client_id
      t.string :punter_id
      t.integer :amount
      t.string :scratched_list
      t.string :serial_number
      t.datetime :bet_placed_at
      t.text :placement_request
      t.text :placement_response
      t.string :game_account_token
      t.string :paymoney_account_number
      t.string :paymoney_account_token
      t.string :p_payment_transaction_id
      t.text :p_payment_request
      t.text :p_payment_response
      t.string :payment_error_code
      t.text :payment_error_description
      t.text :cancel_request
      t.text :cancel_response
      t.boolean :cancelled
      t.datetime :cancelled_at
      t.string :p_cancellation_id
      t.string :suid
      t.integer :win_amount
      t.string :win_reason
      t.string :win_bet_ids
      t.string :win_checksum
      t.text :p_validation_request
      t.text :p_validation_response
      t.string :p_validation_id
      t.boolean :p_validated
      t.datetime :p_validated_at
      t.text :pay_earning_request
      t.text :pay_earning_response
      t.string :p_earning_id
      t.text :pay_refund_request
      t.text :pay_refund_response
      t.string :p_refund_id

      t.timestamps
    end
  end
end
