class CreateBombLogs < ActiveRecord::Migration
  def change
    create_table :bomb_logs do |t|
      t.string :sent_url

      t.timestamps
    end
  end
end
