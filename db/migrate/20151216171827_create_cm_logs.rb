class CreateCmLogs < ActiveRecord::Migration
  def change
    create_table :cm_logs do |t|
      t.string :operation
      t.string :connection_id
      t.string :current_session_id
      t.string :current_session_date
      t.string :current_session_status
      t.string :surrent_session_currency
      t.string :current_session_program_id

      t.timestamps
    end
  end
end
