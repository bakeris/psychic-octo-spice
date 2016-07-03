class AddGameAccountTokenToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :game_account_token, :string
  end
end
