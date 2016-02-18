class AddConfirmationTokenAndConfirmedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :password_reseted_at, :datetime
  end
end
