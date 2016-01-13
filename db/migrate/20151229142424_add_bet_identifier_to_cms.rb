class AddBetIdentifierToCms < ActiveRecord::Migration
  def change
    add_column :cms, :bet_identifier, :string
  end
end
