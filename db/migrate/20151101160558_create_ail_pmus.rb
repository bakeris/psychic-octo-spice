class CreateAilPmus < ActiveRecord::Migration
  def change
    create_table :ail_pmus do |t|

      t.timestamps
    end
  end
end
