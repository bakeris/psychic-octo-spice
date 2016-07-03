class AddUserIdToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :user_id, :integer
  end
end
