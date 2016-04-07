class AddPublishedToAdministrators < ActiveRecord::Migration
  def change
    add_column :administrators, :published, :boolean
  end
end
