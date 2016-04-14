class AddRightFieldsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :create_profile_right, :boolean
    add_column :profiles, :habilitations_right, :boolean
    add_column :profiles, :create_account_right, :boolean
    add_column :profiles, :list_gamers_right, :boolean
    add_column :profiles, :list_loto_transactions_right, :boolean
    add_column :profiles, :list_pmu_plr_transactions_right, :boolean
    add_column :profiles, :list_spc_transactions_right, :boolean
    add_column :profiles, :list_pmu_alr_transactions_right, :boolean
    add_column :profiles, :list_eppl_transactions_right, :boolean
    add_column :profiles, :list_pmu_plr_on_hold_transactions_transactions_right, :boolean
    add_column :profiles, :list_loto_on_hold_transactions_transactions_right, :boolean
    add_column :profiles, :list_spc_on_hold_transactions_transactions_right, :boolean
    add_column :profiles, :list_pmu_alr_on_hold_transactions_transactions_right, :boolean
    add_column :profiles, :list_pmu_plr_winners_transactions_transactions_right, :boolean
    add_column :profiles, :list_loto_winners_transactions_transactions_right, :boolean
    add_column :profiles, :list_spc_winners_transactions_transactions_right, :boolean
    add_column :profiles, :list_pmu_alr_winners_transactions_transactions_right, :boolean
  end
end
