class User < ActiveRecord::Base
  # Callbacks
  before_create :encrypt_password

  # Relationships
  has_many :query_bets
  has_many :ail_lotos
  has_many :ail_pmus
  has_many :eppls
  has_many :bets

  # Set accessible fields
  attr_accessible :civility_id, :sex_id, :pseudo, :firstname, :lastname, :email, :password, :msisdn, :birthdate, :creation_mode_id, :reset_pasword_token, :salt, :confirmation_token, :confirmed_at, :reset_password_token, :password_reseted_at, :account_enabled, :uuid, :last_successful_message, :login_status

# Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    firstname: 'Le nom',
    lastname: "Le prénom",
    email: "L'email",
    password: 'Le mot de passe',
    msisdn: "Le numéro de téléphone",
    birthdate: "La date de naissance",
    uuid: "UUID"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :msisdn, presence: true
  #validates :msisdn, uniqueness: {message: "est déjà inscrit"}
  validates :pseudo, :firstname, :lastname, :password, length: {minimum: 3, maximum: 255}
  #validates :pseudo, uniqueness: true
  validates :email, uniqueness: {allow_blank: true}
  #validates :password, numericality: true
  validates :email, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i, multiline: true, allow_blank: true}
  validate :msisdn_not_a_number?, :right_msisdn_length?, :right_birthdate?

  def self.authenticate_with_email(email, password)
    status = false
    user = User.find_by_email(email)
    if !user.blank?
      if user.password == Digest::SHA2.hexdigest(user.salt + password)
        status = true
      end
    end
    status
  end

  def self.authenticate_with_msisdn(msisdn, password)
    status = false
    user = User.find_by_msisdn(msisdn)
    if !user.blank?
      if user.password == Digest::SHA2.hexdigest(user.salt + password)
        status = true
      end
    end
    status
  end

  def self.authenticate_with_email(email, password)
    status = false
    user = User.find_by_email(email)
    if !user.blank?
      if user.password == Digest::SHA2.hexdigest(user.salt + password)
        status = true
      end
    end
    status
  end

  def self.full_name
    return "#{lastname} #{firstname}"
  end

  private
    def encrypt_password
      self.password = Digest::SHA2.hexdigest(salt + password)
    end

    def msisdn_not_a_number?
    	if msisdn.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil
    	  errors.add(:msisdn, " doit être numérique")
    	end
    end

    def right_msisdn_length?
      if msisdn.length != 8
        errors.add(:msisdn, " doit être sur 8 caractères")
      end
    end

    def right_birthdate?
      if (Date.parse(birthdate.to_s) rescue nil) == nil
        errors.add(:birthdate, " n'est pas valide")
      end
    end
end
