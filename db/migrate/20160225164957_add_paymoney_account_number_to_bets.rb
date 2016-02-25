class AddPaymoneyAccountNumberToBets < ActiveRecord::Migration
  def change
    add_column :bets, :paymoney_account_number, :string
  end
end
