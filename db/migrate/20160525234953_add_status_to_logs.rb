class AddStatusToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :status, :string
  end
end
