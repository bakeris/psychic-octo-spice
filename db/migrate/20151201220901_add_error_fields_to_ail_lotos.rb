class AddErrorFieldsToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :error_code, :string
  end
end
