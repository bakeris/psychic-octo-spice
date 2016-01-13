class CmWager < ActiveRecord::Base

  # Relationship
  belongs_to :cm

  # Accessible fields
  attr_accessible :cm_id, :bet_id, :nb_units, :nb_combinations, :full_box, :selections_string, :winner
end
