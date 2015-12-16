class AddBetValidatedAndBetValidatedAtToEppls < ActiveRecord::Migration
  def change
    add_column :eppls, :bet_validated, :boolean
    add_column :eppls, :bet_validated_at, :datetime
  end
end
