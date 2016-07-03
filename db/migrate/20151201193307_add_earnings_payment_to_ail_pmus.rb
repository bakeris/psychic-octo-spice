class AddEarningsPaymentToAilPmus < ActiveRecord::Migration
  def change
    add_column :ail_pmus, :earning_paid, :boolean
    add_column :ail_pmus, :earning_paid_at, :datetime
  end
end
