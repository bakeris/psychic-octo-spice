class AddSmsNotificationFieldsToBets < ActiveRecord::Migration
  def change
    add_column :bets, :sms_sent, :boolean
    add_column :bets, :sms_content, :text
    add_column :bets, :sms_id, :string
  end
end
