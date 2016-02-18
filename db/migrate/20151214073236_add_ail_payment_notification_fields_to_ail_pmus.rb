class AddAilPaymentNotificationFieldsToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :earning_notification_received, :boolean
    add_column :ail_pmus, :earning_notification_received_at, :datetime
    add_column :ail_pmus, :refund_notification_received, :boolean
    add_column :ail_pmus, :refund_notification_received_at, :datetime
  end
end
