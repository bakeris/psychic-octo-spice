class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.string :license_code
      t.string :pos_code
      t.string :terminal_id
      t.string :account_id
      t.string :account_type
      t.string :transaction_id
      t.string :amount
      t.string :win_amount
      t.string :pal_code
      t.string :event_code
      t.string :bet_code
      t.string :draw_code
      t.string :odd
      t.boolean :validated
      t.datetime :validated_at
      t.string :ticket_id
      t.string :ticket_timestamp
      t.string :transaction_id
      t.boolean :cancelled
      t.datetime :cancelled_at
      t.string :cancellation_timestamp

      t.timestamps
    end
  end
end
