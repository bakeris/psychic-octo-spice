class AddAdditionalFieldsToBets < ActiveRecord::Migration
  def change
    add_column :bets, :formula, :string
  end
end
