class AddOnHoldWinnerPaidAtToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :on_hold_winner_paid_at, :datetime
  end
end
