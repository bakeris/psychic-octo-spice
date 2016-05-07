class AddManagerToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :manager, :string
  end
end
