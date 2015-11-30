class AddPaymoneyFieldsToBets < ActiveRecord::Migration
  def change
    add_column :bets, :bet_placed, :boolean
    add_column :bets, :bet_placed_at, :datetime
    add_column :bets, :paymoney_account_token, :string
    add_column :bets, :error_code, :string
    add_column :bets, :error_description, :text
    add_column :bets, :response_body, :text
    add_column :bets, :bet_cancelled, :boolean
    add_column :bets, :bet_cancelled_at, :datetime
  end
end
