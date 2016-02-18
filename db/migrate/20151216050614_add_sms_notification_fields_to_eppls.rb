class AddSmsNotificationFieldsToEppls < ActiveRecord::Migration
  def change
    add_column :eppls, :sms_sent, :boolean
    add_column :eppls, :sms_content, :text
    add_column :eppls, :sms_id, :string
  end
end
