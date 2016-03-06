class AddOnHoldWinnerPaidAtToBets < ActiveRecord::Migration
  def change
    add_column :bets, :on_hold_winner_paid_at, :datetime
  end
end
