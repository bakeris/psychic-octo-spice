class AddGamerIdToBets < ActiveRecord::Migration
  def change
    add_column :bets, :gamer_id, :string
  end
end
