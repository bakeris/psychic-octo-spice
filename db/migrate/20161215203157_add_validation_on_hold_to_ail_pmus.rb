class AddValidationOnHoldToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :validation_on_hold, :boolean
  end
end
