class Log < ActiveRecord::Base
  attr_accessible :transaction_type, :checkout_amount, :status, :error_log, :response_log, :agent, :sub_agent, :transaction_id, :fee, :remote_ip_address, :transaction_status
end
