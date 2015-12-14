class AddPaymoneyValidationIdToEppls < ActiveRecord::Migration
  def change
    add_column :eppls, :paymoney_validation_id, :string
  end
end
