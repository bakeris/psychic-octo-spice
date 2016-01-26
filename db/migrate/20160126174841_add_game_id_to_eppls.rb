class AddGameIdToEppls < ActiveRecord::Migration
  def change
    add_column :eppls, :game_id, :string
  end
end
