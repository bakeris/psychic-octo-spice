class AddSentBodyToLudwinLogs < ActiveRecord::Migration
  def change
    add_column :ludwin_logs, :sent_body, :text
  end
end
