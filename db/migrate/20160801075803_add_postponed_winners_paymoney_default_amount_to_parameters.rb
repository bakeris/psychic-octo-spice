class AddPostponedWinnersPaymoneyDefaultAmountToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :postponed_winners_paymoney_default_amount, :float
  end
end
