class Profile < ActiveRecord::Base
  has_many :administrators

  # Accessible fields
  attr_accessible :description, :manager, :create_profile_right, :habilitations_right, :create_account_right, :list_gamers_right, :list_loto_transactions_right, :list_pmu_plr_transactions_right, :list_spc_transactions_right, :list_pmu_alr_transactions_right, :list_eppl_transactions_right, :list_pmu_plr_on_hold_transactions_transactions_right, :list_loto_on_hold_transactions_transactions_right, :list_spc_on_hold_transactions_transactions_right, :list_pmu_alr_on_hold_transactions_transactions_right, :list_pmu_plr_winners_transactions_transactions_right, :list_loto_winners_transactions_transactions_right, :list_spc_winners_transactions_transactions_right, :list_pmu_alr_winners_transactions_transactions_right

  # Rename attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :description => "Intitulé",
    :manager => "Responsable du département"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :description, presence: true
  validates :description, uniqueness: true
end
