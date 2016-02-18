class AddBeginAndEndDateToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :begin_date, :string
    add_column :ail_pmus, :end_date, :string
  end
end
