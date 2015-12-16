class AddErrorDescriptionToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :error_description, :string
  end
end
