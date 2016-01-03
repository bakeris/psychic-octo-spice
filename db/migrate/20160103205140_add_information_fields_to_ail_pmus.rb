class AddInformationFieldsToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :starter_horses, :string
    add_column :ail_pmus, :race_details, :text
    add_column :ail_pmus, :bet_status, :string
  end
end
