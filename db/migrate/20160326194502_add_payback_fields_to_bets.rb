class AddPaybackFieldsToBets < ActiveRecord::Migration
  def change
    add_column :bets, :payback_unplaced_bet_request, :text
    add_column :bets, :payback_unplaced_bet_response, :string
    add_column :bets, :payback_unplaced_bet, :boolean
    add_column :bets, :payback_unplaced_bet_at, :datetime
  end
end
