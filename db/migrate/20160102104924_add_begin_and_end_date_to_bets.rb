class AddBeginAndEndDateToBets < ActiveRecord::Migration
  def change
    add_column :bets, :begin_date, :string
    add_column :bets, :end_date, :string
  end
end
