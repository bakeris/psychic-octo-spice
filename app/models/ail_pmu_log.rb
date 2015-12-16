class AilPmuLog < ActiveRecord::Base
  # Accessible fields
  attr_accessible :operation, :transaction_id, :sent_params, :response_body, :remote_ip_address, :error_code
end
