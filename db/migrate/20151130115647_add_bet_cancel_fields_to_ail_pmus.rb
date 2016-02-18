class AddBetCancelFieldsToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :bet_cancelled, :boolean
    add_column :ail_pmus, :bet_cancelled_at, :datetime
  end
end
