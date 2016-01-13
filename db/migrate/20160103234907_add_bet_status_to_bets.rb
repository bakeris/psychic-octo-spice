class AddBetStatusToBets < ActiveRecord::Migration
  def change
    add_column :bets, :bet_status, :string
  end
end
