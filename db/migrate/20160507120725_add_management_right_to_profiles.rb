class AddManagementRightToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :management_right, :boolean
  end
end
