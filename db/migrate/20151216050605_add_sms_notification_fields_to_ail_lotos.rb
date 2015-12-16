class AddSmsNotificationFieldsToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :sms_sent, :boolean
    add_column :ail_lotos, :sms_content, :text
    add_column :ail_lotos, :sms_id, :string
  end
end
