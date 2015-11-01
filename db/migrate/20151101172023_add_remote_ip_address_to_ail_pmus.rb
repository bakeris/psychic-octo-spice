class AddRemoteIpAddressToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :remote_ip_address, :string
  end
end
