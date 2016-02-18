class AddLastSuccessfulMessageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_succesful_message, :string
    add_column :users, :integer, :string
  end
end
