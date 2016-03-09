class AddSmsNotificationsToCms < ActiveRecord::Migration
  def change
    add_column :cms, :sms_sent, :boolean
    add_column :cms, :sms_content, :text
    add_column :cms, :sms_id, :string
    add_column :cms, :sms_status, :string
  end
end
