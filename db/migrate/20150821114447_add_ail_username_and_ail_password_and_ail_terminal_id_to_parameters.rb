class AddAilUsernameAndAilPasswordAndAilTerminalIdToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :ail_username, :string
    add_column :parameters, :ail_password, :string
    add_column :parameters, :ail_terminal_id, :string
  end
end
