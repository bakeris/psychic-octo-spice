class AddEarningAndRefundFieldsToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :earning_amount, :string
    add_column :ail_pmus, :refund_amount, :string
    add_column :ail_pmus, :refund_paid, :boolean
    add_column :ail_pmus, :refund_paid_at, :datetime
    add_column :ail_pmus, :paymoney_earning_id, :string
    add_column :ail_pmus, :paymoney_refund_id, :string
  end
end
