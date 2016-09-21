class BetCoupon < ActiveRecord::Base
  # Accessible fields
  attr_accessible :bet_id, :pal_code, :event_code, :bet_code, :draw_code, :odd, :begin_date, :teams, :sport, :is_fix, :handicap, :flag_bonus, :amount

  # Relationships
  belongs_to :bet
end
