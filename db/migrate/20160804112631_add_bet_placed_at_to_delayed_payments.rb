class AddBetPlacedAtToDelayedPayments < ActiveRecord::Migration
  def change
    add_column :delayed_payments, :bet_placed_at, :string
  end
end
