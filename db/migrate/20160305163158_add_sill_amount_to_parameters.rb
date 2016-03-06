class AddSillAmountToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :sill_amount, :float
  end
end
