class CreateLudwinLogs < ActiveRecord::Migration
  def change
    create_table :ludwin_logs do |t|
      t.string :operation
      t.string :transaction_id
      t.string :language
      t.string :sport_code

      t.timestamps
    end
  end
end
