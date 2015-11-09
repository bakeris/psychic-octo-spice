class CorrectAilPmus < ActiveRecord::Migration
  def change
    remove_column :ail_pmus, :placement_acknowledge
    remove_column :ail_pmus, :cancellation_acknowledge
    remove_column :ail_pmus, :refund_acknowledge

    add_column :ail_pmus, :placement_acknowledge, :boolean
    add_column :ail_pmus, :cancellation_acknowledge, :boolean
    add_column :ail_pmus, :refund_acknowledge, :boolean
  end
end
