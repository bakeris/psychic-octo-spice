class CreateLudwins < ActiveRecord::Migration
  def change
    create_table :ludwins do |t|

      t.timestamps
    end
  end
end
