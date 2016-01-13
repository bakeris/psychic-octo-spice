class AddTransactionIdToCms < ActiveRecord::Migration
  def change
    add_column :cms, :transaction_id, :string
  end
end
