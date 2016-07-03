class AddSmsStatusNotificationFieldsToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :sms_status, :string
  end
end
