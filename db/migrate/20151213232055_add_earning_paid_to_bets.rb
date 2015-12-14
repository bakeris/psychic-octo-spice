class AddEarningPaidToBets < ActiveRecord::Migration
  def change
    add_column :bets, :earning_paid, :boolean
    add_column :bets, :earning_paid_at, :datetime
  end
end
