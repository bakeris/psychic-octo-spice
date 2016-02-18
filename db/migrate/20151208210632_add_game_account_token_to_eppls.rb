class AddGameAccountTokenToEppls < ActiveRecord::Migration
  def change
    add_column :eppls, :game_account_token, :string
  end
end
