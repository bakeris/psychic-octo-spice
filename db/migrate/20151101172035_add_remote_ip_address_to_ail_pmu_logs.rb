class AddRemoteIpAddressToAilPmuLogs < ActiveRecord::Migration
  def change
    add_column :ail_pmu_logs, :remote_ip_address, :string
  end
end
