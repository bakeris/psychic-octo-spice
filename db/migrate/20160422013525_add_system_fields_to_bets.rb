class AddSystemFieldsToBets < ActiveRecord::Migration
  def change
    add_column :bets, :system_code, :string
    add_column :bets, :number_of_combinations, :string
  end
end
