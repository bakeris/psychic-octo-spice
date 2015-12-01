class AddPaymoneyCancelAndPaymentFieldsToAilLotos < ActiveRecord::Migration
  def change
    add_column :ail_lotos, :cancellation_paymoney_id, :string
    add_column :ail_lotos, :payment_paymoney_id, :string
  end
end
