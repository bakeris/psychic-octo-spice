class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :transaction_type
      t.string :checkout_amount
      t.text :response_log
      t.boolean :status
      t.string :agent
      t.string :sub_agent
      t.string :transaction_id
      t.string :fee

      t.timestamps
    end
  end
end
