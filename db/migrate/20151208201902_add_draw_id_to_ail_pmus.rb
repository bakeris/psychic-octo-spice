class AddDrawIdToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :draw_id, :string
  end
end
