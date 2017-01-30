class AddPaymoneyAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paymoney_account, :string
  end
end
