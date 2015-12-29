class AddEvaluationFieldsToCmLogs < ActiveRecord::Migration
  def change
    add_column :cm_logs, :get_eval_request, :text
    add_column :cm_logs, :get_eval_response, :text
    add_column :cm_logs, :get_eval_code, :string
  end
end
