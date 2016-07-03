class AddDepositMadeToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :deposit_made, :boolean
  end
end
