class AddUserIdToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :user_id, :integer
  end
end
