class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.belongs_to :civility, index: true
      t.belongs_to :sex, index: true
      t.string :pseudo
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :password
      t.string :msisdn, limit: 13
      t.date :birthdate
      t.belongs_to :creation_mode, index: true
      t.string :reset_password_token

      t.timestamps
    end
  end
end
