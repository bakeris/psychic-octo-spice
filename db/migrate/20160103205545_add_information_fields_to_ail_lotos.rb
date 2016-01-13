class AddInformationFieldsToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :draw_day, :string
    add_column :ail_lotos, :draw_number, :string
    add_column :ail_lotos, :bet_status, :string
  end
end
