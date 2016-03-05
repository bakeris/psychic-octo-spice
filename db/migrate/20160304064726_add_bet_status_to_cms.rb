class AddBetStatusToCms < ActiveRecord::Migration
  def change
    add_column :cms, :bet_status, :string
  end
end
