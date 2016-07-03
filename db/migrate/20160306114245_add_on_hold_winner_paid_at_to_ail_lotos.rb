class AddOnHoldWinnerPaidAtToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :on_hold_winner_paid_at, :datetime
  end
end
