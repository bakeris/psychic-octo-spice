class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :description
      t.boolean :users_list_right
      t.boolean :payment_on_hold_right
      t.boolean :pmu_plr_right
      t.boolean :loto_right
      t.boolean :pmu_alr_right
      t.boolean :spc_right
      t.boolean :eppl_right

      t.timestamps
    end
  end
end
