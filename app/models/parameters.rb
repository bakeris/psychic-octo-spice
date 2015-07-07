class Parameters < ActiveRecord::Base

  # Set accessible fields
  attr_accessible :registration_url, :reset_password_url

end
