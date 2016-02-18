class AddWinnerToCmWagers < ActiveRecord::Migration
  def change
    add_column :cm_wagers, :winner, :boolean
  end
end
