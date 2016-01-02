class BetCoupon < ActiveRecord::Base
  # Accessible fields
  attr_accessible :bet_id, :pal_code, :event_code, :bet_code, :draw_code, :odd, :begin_date

  # Relationships
  belongs_to :bet
end
