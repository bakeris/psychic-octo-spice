class AddRemoteIpToEppl < ActiveRecord::Migration
  def change
    add_column :eppls, :remote_ip, :string
  end
end
