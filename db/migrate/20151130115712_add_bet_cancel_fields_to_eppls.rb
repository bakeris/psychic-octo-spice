class AddBetCancelFieldsToEppls < ActiveRecord::Migration
  def change
    add_column :eppls, :bet_cancelled, :boolean
    add_column :eppls, :bet_cancelled_at, :datetime
  end
end
