class CreateCreationModes < ActiveRecord::Migration
  def change
    create_table :creation_modes do |t|
      t.string :name
      t.string :token

      t.timestamps
    end
  end
end
