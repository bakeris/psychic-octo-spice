class AddSmsStatusNotificationFieldsToEppls < ActiveRecord::Migration
  def change
    add_column :eppls, :sms_status, :string
  end
end
