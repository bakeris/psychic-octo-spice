class AddAilPaymentNotificationFieldsToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :earning_notification_received, :boolean
    add_column :ail_lotos, :earning_notification_received_at, :datetime
    add_column :ail_lotos, :refund_notification_received, :boolean
    add_column :ail_lotos, :refund_notification_received_at, :datetime
  end
end
