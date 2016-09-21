class AddAmountToBetCoupons < ActiveRecord::Migration
  def change
    add_column :bet_coupons, :amount, :string
  end
end
