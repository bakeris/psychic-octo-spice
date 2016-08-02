class CreateDelayedPayments < ActiveRecord::Migration
  def change
    create_table :delayed_payments do |t|
      t.string :type
      t.string :transaction_id
      t.string :ticket_id
      t.string :cheque_id
      t.string :firstname
      t.string :lastname
      t.string :identity_number
      t.float :cheque_amount
      t.string :paymoney_account_number
      t.float :paymoney_amount
      t.text :winner_paymoney_account_request
      t.text :winner_paymoney_account_response
      t.text :paymoney_credit_request
      t.text :paymoney_credit_response
      t.boolean :paymoney_credit_status
      t.text :cheque_credit_request
      t.text :cheque_credit_response
      t.boolean :cheque_credit_status
      t.text :payback_request
      t.text :payback_response
      t.boolean :payback_status

      t.timestamps
    end
  end
end
