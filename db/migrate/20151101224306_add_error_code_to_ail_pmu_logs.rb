class AddErrorCodeToAilPmuLogs < ActiveRecord::Migration
  def change
    add_column :ail_pmu_logs, :error_code, :string
  end
end
