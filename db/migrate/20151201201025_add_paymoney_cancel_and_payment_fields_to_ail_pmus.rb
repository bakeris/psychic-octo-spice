class AddPaymoneyCancelAndPaymentFieldsToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :cancellation_paymoney_id, :string
    add_column :ail_pmus, :payment_paymoney_id, :string
  end
end
