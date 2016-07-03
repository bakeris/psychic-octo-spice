class AddBetValidationFieldsToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :bet_validated, :boolean
    add_column :ail_lotos, :bet_validated_at, :datetime
  end
end
