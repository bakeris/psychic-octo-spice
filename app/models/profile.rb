class Profile < ActiveRecord::Base
  has_many :administrators

  # Accessible fields
  attr_accessible :description

  # Rename attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :description => "Intitulé"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :description, presence: true
  validates :description, uniqueness: true
end
