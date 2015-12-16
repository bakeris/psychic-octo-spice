class AddPaymoneyAccountTokenToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :paymoney_account_token, :string
  end
end
