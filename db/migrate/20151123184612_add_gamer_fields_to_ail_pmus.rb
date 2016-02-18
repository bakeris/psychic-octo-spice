class AddGamerFieldsToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :gamer_id, :string
    add_column :ail_pmus, :paymoney_account_number, :string
    add_column :ail_pmus, :paymoney_transaction_id, :string
    add_column :ail_pmus, :bet_placed, :boolean
    add_column :ail_pmus, :bet_placed_at, :datetime
  end
end
