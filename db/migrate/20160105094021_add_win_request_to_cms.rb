class AddWinRequestToCms < ActiveRecord::Migration
  def change
    add_column :cms, :win_request, :text
    add_column :cms, :win_response, :text
  end
end
