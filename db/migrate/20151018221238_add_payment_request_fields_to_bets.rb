class AddPaymentRequestFieldsToBets < ActiveRecord::Migration
  def change
    add_column :bets, :pr_transaction_id, :string
    add_column :bets, :pr_status, :boolean
  end
end
