class AddTransactionTypeToDelayedPayments < ActiveRecord::Migration
  def change
    add_column :delayed_payments, :transaction_type, :string
  end
end
