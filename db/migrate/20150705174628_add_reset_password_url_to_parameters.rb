class AddResetPasswordUrlToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :reset_password_url, :string
  end
end
