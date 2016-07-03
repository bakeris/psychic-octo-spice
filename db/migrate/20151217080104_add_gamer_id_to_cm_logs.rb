class AddGamerIdToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :gamer_id, :string
  end
end
