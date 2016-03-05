class AddOperationToEppls < ActiveRecord::Migration
  def change
    add_column :eppls, :operation, :string
  end
end
