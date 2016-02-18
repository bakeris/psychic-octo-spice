class AddPrStatusDatetimeToBets < ActiveRecord::Migration
  def change
    add_column :bets, :payment_status_datetime, :string
  end
end
