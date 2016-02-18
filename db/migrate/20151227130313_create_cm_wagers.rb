class CreateCmWagers < ActiveRecord::Migration
  def change
    create_table :cm_wagers do |t|
      t.integer :cm_id
      t.string :bet_id
      t.string :nb_units
      t.string :nb_combinations
      t.string :full_box
      t.string :selections_string

      t.timestamps
    end
  end
end
