class CreateAilPmuLogs < ActiveRecord::Migration
  def change
    create_table :ail_pmu_logs do |t|
      t.string :operation
      t.string :transaction_id
      t.text :sent_params
      t.text :response_body

      t.timestamps
    end
  end
end
