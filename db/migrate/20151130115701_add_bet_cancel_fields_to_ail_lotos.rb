class AddBetCancelFieldsToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :bet_cancelled, :boolean
    add_column :ail_lotos, :bet_cancelled_at, :datetime
  end
end
