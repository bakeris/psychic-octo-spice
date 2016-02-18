class AddPaymoneyAccountTokenToEppl < ActiveRecord::Migration
  def change
    add_column :eppls, :paymoney_account_token, :string
  end
end
