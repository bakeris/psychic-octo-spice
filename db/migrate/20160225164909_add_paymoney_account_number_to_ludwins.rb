class AddPaymoneyAccountNumberToLudwins < ActiveRecord::Migration
  def change
    add_column :ludwins, :paymoney_account_number, :string
  end
end
