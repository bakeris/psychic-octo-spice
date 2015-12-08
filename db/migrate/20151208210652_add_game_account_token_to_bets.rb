class AddGameAccountTokenToBets < ActiveRecord::Migration
  def change
    add_column :bets, :game_account_token, :string
  end
end
