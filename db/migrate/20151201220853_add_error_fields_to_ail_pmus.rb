class AddErrorFieldsToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :error_code, :string
  end
end
