class AddPaymoneyAccountNumberToEppls < ActiveRecord::Migration
  def change
    add_column :eppls, :paymoney_account_number, :string
  end
end
