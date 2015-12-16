class CreateBetCoupons < ActiveRecord::Migration
  def change
    create_table :bet_coupons do |t|
      t.integer :bet_id
      t.string :pal_code
      t.string :event_code
      t.string :bet_code
      t.string :draw_code
      t.string :odd

      t.timestamps
    end
  end
end
