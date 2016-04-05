class AddCreatedByToAdministrators < ActiveRecord::Migration
  def change
    add_column :administrators, :created_by, :integer
  end
end
