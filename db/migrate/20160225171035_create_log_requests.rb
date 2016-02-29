class CreateLogRequests < ActiveRecord::Migration
  def change
    create_table :log_requests do |t|
      t.string :description
      t.text :request

      t.timestamps
    end
  end
end
