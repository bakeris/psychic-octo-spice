class AddPaymoneyPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paymoney_password, :string
  end
end
