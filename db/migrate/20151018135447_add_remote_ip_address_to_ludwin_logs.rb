class AddRemoteIpAddressToLudwinLogs < ActiveRecord::Migration
  def change
    add_column :ludwin_logs, :remote_ip_address, :string
  end
end
