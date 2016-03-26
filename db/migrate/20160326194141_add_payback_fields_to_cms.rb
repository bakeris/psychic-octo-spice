class AddPaybackFieldsToCms < ActiveRecord::Migration
  def change
    add_column :cms, :payback_unplaced_bet_request, :text
    add_column :cms, :payback_unplaced_bet_response, :string
    add_column :cms, :payback_unplaced_bet, :boolean
    add_column :cms, :payback_unplaced_bet_at, :datetime
  end
end
