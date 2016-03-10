class Log < ActiveRecord::Base
  attr_accessible :transaction_type, :checkout_amount, :status, :error_log, :response_log, :agent, :sub_agent, :transaction_id, :fee
end
