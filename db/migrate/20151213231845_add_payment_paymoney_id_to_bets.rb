class AddPaymentPaymoneyIdToBets < ActiveRecord::Migration
  def change
    add_column :bets, :payment_paymoney_id, :string
  end
end
