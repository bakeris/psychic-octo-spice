class CreateQueryBets < ActiveRecord::Migration
  def change
    create_table :query_bets do |t|
      t.integer :user_id
      t.integer :confirm_id
      t.datetime :op_code
      t.string :bet_code
      t.string :bet_modifier
      t.string :selector1
      t.string :selector2
      t.string :repeats
      t.string :special_count
      t.string :normal_count
      t.string :entries
      t.string :status
      t.string :response_message_id
      t.string :response_user_id
      t.string :response_datetime
      t.string :audit_number
      t.float :bet_cost_amount
      t.string :response_bet_code
      t.string :response_bet_modifier
      t.string :response_selector1
      t.string :response_selector2
      t.string :response_repeats
      t.string :response_special_count
      t.string :response_normal_count
      t.string :response_entries
      t.string :error_code
      t.text :error_message

      t.timestamps
    end
  end
end
