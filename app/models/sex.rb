class Sex < ActiveRecord::Base
  # Relationships
  has_many :user

  # Set accessible fields
  attr_accessible :name
end
