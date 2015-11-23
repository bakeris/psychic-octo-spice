class AddResponseBodyToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :response_body, :text
  end
end
