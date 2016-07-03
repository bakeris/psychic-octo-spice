class RemoveCouponDataFromBets < ActiveRecord::Migration
  def change
     remove_column :bets, :pal_code
     remove_column :bets, :event_code
     remove_column :bets, :bet_code
     remove_column :bets, :draw_code
     remove_column :bets, :odd
  end
end
