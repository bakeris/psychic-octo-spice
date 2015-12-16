class AddPaymoneyValidationIdToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :paymoney_validation_id, :string
  end
end
