class AddAccountLabelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_label, :string
  end
end
