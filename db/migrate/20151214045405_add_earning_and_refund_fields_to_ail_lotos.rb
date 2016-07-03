class AddEarningAndRefundFieldsToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :earning_amount, :string
    add_column :ail_lotos, :refund_amount, :string
    add_column :ail_lotos, :refund_paid, :boolean
    add_column :ail_lotos, :refund_paid_at, :datetime
    add_column :ail_lotos, :paymoney_earning_id, :string
    add_column :ail_lotos, :paymoney_refund_id, :string
  end
end
