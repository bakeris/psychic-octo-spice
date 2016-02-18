class AddGamerIdToEppls < ActiveRecord::Migration
  def change
    add_column :eppls, :gamer_id, :string
  end
end
