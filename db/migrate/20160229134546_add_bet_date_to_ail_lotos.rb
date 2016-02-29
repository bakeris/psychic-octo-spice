class AddBetDateToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :bet_date, :string
  end
end
