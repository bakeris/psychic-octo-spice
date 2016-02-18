class AddPaymoneyTransactionIdToEppl < ActiveRecord::Migration
  def change
    add_column :eppls, :paymoney_transaction_id, :string
  end
end
