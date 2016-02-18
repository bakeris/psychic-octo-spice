class AddRaceIdToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :race_id, :string
  end
end
