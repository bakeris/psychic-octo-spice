class AddDrawIdToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :draw_id, :string
  end
end
