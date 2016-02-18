class AddPaymoneyCancelAndPaymentFieldsToEppls < ActiveRecord::Migration
  def change
    add_column :eppls, :cancellation_paymoney_id, :string
    add_column :eppls, :payment_paymoney_id, :string
  end
end
