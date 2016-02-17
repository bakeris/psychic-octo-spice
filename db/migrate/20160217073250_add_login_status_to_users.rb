class AddLoginStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login_status, :string
  end
end
