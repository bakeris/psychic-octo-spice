class AddBetAmountToDelayedPayments < ActiveRecord::Migration
  def change
    add_column :delayed_payments, :bet_amount, :string
  end
end
