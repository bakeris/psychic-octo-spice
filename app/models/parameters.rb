class Parameters < ActiveRecord::Base

  # Set accessible fields
  attr_accessible :registration_url, :reset_password_url, :ail_username, :ail_password, :ail_terminal_id

end
