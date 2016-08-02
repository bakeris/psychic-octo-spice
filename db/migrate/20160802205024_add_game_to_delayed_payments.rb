class AddGameToDelayedPayments < ActiveRecord::Migration
  def change
    add_column :delayed_payments, :game, :string
  end
end
