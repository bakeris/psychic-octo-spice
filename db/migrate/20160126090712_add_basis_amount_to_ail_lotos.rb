class AddBasisAmountToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :basis_amount, :string
  end
end
