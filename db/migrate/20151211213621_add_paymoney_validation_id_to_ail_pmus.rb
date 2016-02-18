class AddPaymoneyValidationIdToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :paymoney_validation_id, :string
  end
end
