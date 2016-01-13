class AddAdditionalFieldsToBetCoupons < ActiveRecord::Migration
  def change
    add_column :bet_coupons, :teams, :string
    add_column :bet_coupons, :sport, :string
  end
end
