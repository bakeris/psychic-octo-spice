class AddFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :program_id, :string
    add_column :cm_logs, :program_type, :string
    add_column :cm_logs, :program_name, :string
    add_column :cm_logs, :program_date, :string
    add_column :cm_logs, :program_status, :string
    add_column :cm_logs, :race_ids, :string
  end
end
