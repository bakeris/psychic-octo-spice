class AddGamersListRightToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :gamers_list_right, :boolean
  end
end
