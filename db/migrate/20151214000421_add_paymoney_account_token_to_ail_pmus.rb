class AddPaymoneyAccountTokenToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :paymoney_account_token, :string
  end
end
