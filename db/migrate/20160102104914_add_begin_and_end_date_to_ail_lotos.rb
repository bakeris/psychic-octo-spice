class AddBeginAndEndDateToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :begin_date, :string
    add_column :ail_lotos, :end_date, :string
  end
end
