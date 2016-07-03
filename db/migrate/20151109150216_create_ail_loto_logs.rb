class CreateAilLotoLogs < ActiveRecord::Migration
  def change
    create_table :ail_loto_logs do |t|
      t.string :operation
      t.string :transaction_id
      t.text :sent_params
      t.text :response_body
      t.string :remote_ip_address
      t.string :error_code

      t.timestamps
    end
  end
end
