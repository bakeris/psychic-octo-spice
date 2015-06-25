class CreationMode < ActiveRecord::Base
  # Relationships
  has_one :user

  # Set accessible fields
  attr_accessible :name, :token
end
