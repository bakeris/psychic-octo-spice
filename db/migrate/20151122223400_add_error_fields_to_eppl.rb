class AddErrorFieldsToEppl < ActiveRecord::Migration
  def change
    add_column :eppls, :error_code, :string
    add_column :eppls, :error_description, :text
    add_column :eppls, :response_body, :string
  end
end
