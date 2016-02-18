class AddPaymoneyFieldsToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :gamer_id, :string
    add_column :ail_lotos, :paymoney_account_number, :string
    add_column :ail_lotos, :paymoney_transaction_id, :string
    add_column :ail_lotos, :bet_placed, :boolean
    add_column :ail_lotos, :bet_placed_at, :datetime
    add_column :ail_lotos, :error_description, :text
    add_column :ail_lotos, :response_body, :text
  end
end
