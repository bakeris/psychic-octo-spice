class AddEarningsPaymentToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :earning_paid, :boolean
    add_column :ail_lotos, :earning_paid_at, :datetime
  end
end
