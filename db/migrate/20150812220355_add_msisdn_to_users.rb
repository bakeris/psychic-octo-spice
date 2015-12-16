class AddMsisdnToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :msisdn
    add_column :users, :msisdn, :string, limit: 20
  end
end
