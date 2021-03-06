class User < ActiveRecord::Base
  # Callbacks
  before_create :encrypt_password

  # Relationships
  has_many :query_bets
  has_many :ail_lotos
  has_many :ail_pmus
  has_many :eppls
  has_many :bets
  belongs_to :civility
  belongs_to :sex

  # Set accessible fields
  attr_accessible :civility_id, :sex_id, :pseudo, :firstname, :lastname, :email, :password, :msisdn, :birthdate, :creation_mode_id, :reset_pasword_token, :salt, :confirmation_token, :confirmed_at, :reset_password_token, :password_reseted_at, :account_enabled, :uuid, :paymoney_account, :last_successful_message, :login_status, :last_connection_date, :confirmed_at

# Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    firstname: 'Le nom',
    lastname: "Le prénom",
    email: "L'email",
    password: 'Le mot de passe',
    msisdn: "Le numéro de téléphone",
    birthdate: "La date de naissance",
    uuid: "UUID",
    paymoney_account: "Numéro de compte Paymoney"
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
  validates :email, :msisdn, uniqueness: {allow_blank: true}
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

  def self.to_csv
    attributes = %w{ID Email Nom Prénom Téléphone Civilité Sexe Id-parieur Compte-Paymoney Date-de-naissance Date-de-création Date-dactivation Date-de-dernière-connexion}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << [user.id, user.email, user.firstname, user.firstname, user.msisdn, (user.civility.name rescue nil), (user.sex.name rescue nil), user.uuid, user.paymoney_account, user.birthdate, user.created_at, user.confirmed_at, user.last_connection_date]
        #csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

  def full_name
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
