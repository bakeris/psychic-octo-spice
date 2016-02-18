class AddRemoteIpAddressToBets < ActiveRecord::Migration
  def change
    add_column :bets, :remote_ip_address, :string
  end
end
