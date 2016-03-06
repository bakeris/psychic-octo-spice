class AddOnHoldWinnerPaidAtToCms < ActiveRecord::Migration
  def change
    add_column :cms, :on_hold_winner_paid_at, :datetime
  end
end
