class AddGameAccountTokenToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :game_account_token, :string
  end
end
