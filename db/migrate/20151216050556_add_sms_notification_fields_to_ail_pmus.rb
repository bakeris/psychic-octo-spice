class AddSmsNotificationFieldsToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :sms_sent, :boolean
    add_column :ail_pmus, :sms_content, :text
    add_column :ail_pmus, :sms_id, :string
  end
end
