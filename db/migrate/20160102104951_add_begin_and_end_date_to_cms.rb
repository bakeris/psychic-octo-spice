class AddBeginAndEndDateToCms < ActiveRecord::Migration
  def change
    add_column :cms, :begin_date, :string
    add_column :cms, :end_date, :string
  end
end
