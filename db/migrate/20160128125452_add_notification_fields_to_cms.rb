class AddNotificationFieldsToCms < ActiveRecord::Migration
  def change
    add_column :cms, :notify_session_request_body, :text
    add_column :cms, :notify_session_request_result, :text
  end
end
