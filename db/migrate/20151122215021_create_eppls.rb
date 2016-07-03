class CreateEppls < ActiveRecord::Migration
  def change
    create_table :eppls do |t|
      t.string :transaction_id
      t.string :paymoney_account
      t.string :transaction_amount
      t.boolean :bet_placed
      t.datetime :bet_placed_at
      t.boolean :earning_paid
      t.datetime :earning_paid_at

      t.timestamps
    end
  end
end
