class AddPaymentTypeToDelayedPayments < ActiveRecord::Migration
  def change
    add_column :delayed_payments, :payment_type, :string
  end
end
