class AddLastConnectionDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_connection_date, :datetime
  end
end
