class AddPaymoneyFieldsToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :paymoney_request, :string
    add_column :deposits, :paymoney_response, :text
    add_column :deposits, :paymoney_transaction_id, :string
  end
end
