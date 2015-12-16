class AddSmsStatusNotificationFieldsToBets < ActiveRecord::Migration
  def change
    add_column :bets, :sms_status, :string
  end
end
