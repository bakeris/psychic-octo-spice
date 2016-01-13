class AddGetProgramErrorResponseFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :get_program_error_response, :text
  end
end
