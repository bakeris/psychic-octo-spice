class Administrator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :profile

  attr_accessible :firstname, :lastname, :phone_number, :email, :password, :password_confirmation, :current_password, :profile_id, :created_by, :published

  # Rename attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :firstname => "Nom",
    :lastname => "Prénoms",
    :phone_number => "Numéro de téléphone",
    :email => "Adresse email",
    :password => "Mot de passe",
    :current_password => "Mot de passe actuel",
    :password_confirmation => "Confirmation du mot de passe",
    :profile_id => "Profil",
    :created_by => "Créé par"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validators
  validates :firstname, :lastname, :phone_number, presence: true
  validates :firstname, :lastname, length: {minimum: 2, allow_blank: true}
  validates :phone_number, numericality: {message: "n'est pas numérique", allow_blank: true}
  validates :phone_number, length: {minimum: 8, maximum: 13, allow_blank: true}

   # Custom functions
   def full_name
    return "#{lastname} #{firstname}"
   end

end
