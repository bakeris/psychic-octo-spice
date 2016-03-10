class CreateLotoBetTypes < ActiveRecord::Migration
  def change
    create_table :loto_bet_types do |t|
      t.string :code
      t.string :category
      t.string :description

      t.timestamps
    end
  end
end
