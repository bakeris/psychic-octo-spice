class Sex < ActiveRecord::Base
  # Relationships
  has_one :user

  # Set accessible fields
  attr_accessible :name
end
