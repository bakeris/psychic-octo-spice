class AddBeginDateToBetCoupons < ActiveRecord::Migration
  def change
    add_column :bet_coupons, :begin_date, :string
  end
end
