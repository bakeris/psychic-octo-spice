class AddUserIdToAilEppl < ActiveRecord::Migration
  def change
    add_column :eppls, :user_id, :integer
  end
end
