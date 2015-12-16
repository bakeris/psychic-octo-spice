class AddBetValidationFieldsToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :bet_validated, :boolean
    add_column :ail_pmus, :bet_validated_at, :datetime
  end
end
