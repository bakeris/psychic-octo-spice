class AddRemoteIpToCms < ActiveRecord::Migration
  def change
    add_column :cms, :remote_ip, :string
  end
end
