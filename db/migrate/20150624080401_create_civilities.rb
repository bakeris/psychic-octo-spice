class CreateCivilities < ActiveRecord::Migration
  def change
    create_table :civilities do |t|
      t.string :name

      t.timestamps
    end
  end
end
