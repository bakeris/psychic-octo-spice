class AddSmsStatusNotificationFieldsToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :sms_status, :string
  end
end
