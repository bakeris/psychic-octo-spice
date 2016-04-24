class AddSystemBetFieldsToBetCoupons < ActiveRecord::Migration
  def change
    add_column :bet_coupons, :is_fix, :string
    add_column :bet_coupons, :handicap, :string
    add_column :bet_coupons, :flag_bonus, :string
  end
end
