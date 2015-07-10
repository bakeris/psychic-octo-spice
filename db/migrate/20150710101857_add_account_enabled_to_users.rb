class AddAccountEnabledToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_enabled, :boolean
  end
end
