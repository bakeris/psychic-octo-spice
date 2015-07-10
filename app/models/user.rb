class User < ActiveRecord::Base
  # Callbacks
  before_create :encrypt_password

  # Relationships

  # Set accessible fields
  attr_accessible :civility_id, :sex_id, :pseudo, :firstname, :lastname, :email, :password, :msisdn, :birthdate, :creation_mode_id, :reset_pasword_token, :salt, :confirmation_token, :confirmed_at, :reset_password_token, :password_reseted_at

  # Validations
  #validates :msisdn, presence: true
  #validates :msisdn, uniqueness: true
  #validates :pseudo, :firstname, :lastname, length: {minimum: 3, maximum: 255, allow_blank: true}
  #validates :pseudo, uniqueness: true
  #validates :email, uniqueness: {allow_blank: true}
  validates :email, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i, multiline: true, allow_blank: true}
  validate :msisdn_not_a_number?, :right_msisdn_length?, :right_birthdate?

  def self.authenticate_with_email(email, password)
    status = false
    user = User.find_by_email(email)
    if !user.blank?
      if user.password = Digest::SHA2.hexdigest(user.salt + password)
        status = true
      end
    end
    status
  end

  def self.authenticate_with_msisdn(msisdn, password)
    status = false
    user = User.find_by_msisdn(msisdn)
    if !user.blank?
      if user.password = Digest::SHA2.hexdigest(user.salt + password)
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
