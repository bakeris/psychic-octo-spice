class AddGetProgramErrorFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :get_program_error_code, :string
    add_column :cm_logs, :get_program_error_description, :text
  end
end
