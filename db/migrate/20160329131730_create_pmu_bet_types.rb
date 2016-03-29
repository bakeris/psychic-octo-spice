class CreatePmuBetTypes < ActiveRecord::Migration
  def change
    create_table :pmu_bet_types do |t|
      t.string :code
      t.string :category
      t.string :description

      t.timestamps
    end
  end
end
