class AddEarningTransactionIdToEppl < ActiveRecord::Migration
  def change
    add_column :eppls, :earning_transaction_id, :string
  end
end
