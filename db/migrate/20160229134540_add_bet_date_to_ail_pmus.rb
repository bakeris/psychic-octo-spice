class AddBetDateToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :bet_date, :string
  end
end
