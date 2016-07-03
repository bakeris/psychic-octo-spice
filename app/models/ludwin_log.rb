class LudwinLog < ActiveRecord::Base

  # Set accessible fields
  attr_accessible :operation, :transaction_id, :language, :sport_code, :error_code, :response_body, :sent_body, :remote_ip_address
end
