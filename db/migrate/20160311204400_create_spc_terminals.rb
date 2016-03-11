class CreateSpcTerminals < ActiveRecord::Migration
  def change
    create_table :spc_terminals do |t|
      t.integer :code
      t.boolean :busy

      t.timestamps
    end
  end
end
