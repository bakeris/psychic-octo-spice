class AddBeginAndEndDateToEppls < ActiveRecord::Migration
  def change
    add_column :eppls, :begin_date, :string
    add_column :eppls, :end_date, :string
  end
end
