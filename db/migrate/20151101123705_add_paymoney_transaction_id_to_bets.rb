class AddPaymoneyTransactionIdToBets < ActiveRecord::Migration
  def change
    add_column :bets, :paymoney_transaction_id, :string
  end
end
