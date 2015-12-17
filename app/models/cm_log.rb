class CmLog < ActiveRecord::Base
  # Accessible fields
  attr_accessible :operation, :connection_id, :current_session_id, :current_session_date, :current_session_status, :surrent_session_currency, :current_session_program_id, :program_id, :program_type, :program_name, :program_date, :program_status, :race_ids, :gamer_id, :login_error_code, :login_error_description
end
