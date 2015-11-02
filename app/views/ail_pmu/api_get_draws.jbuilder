if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.draws @draws_list do |draw|
    draw = (JSON.parse(draw) rescue nil)
    unless draw.blank?
      json.draw_id draw.at('drawID').content
      json.system_name draw.at('systemName').content
      json.draw_type draw.at('DrawType').content
      json.selector1 draw.at('selector1').content
      json.selector2 draw.at('selector2').content
      json.draw_state draw.at('drawState').content
      json.number_of_entries draw.at('numberOfEntries').content
      json.payout_released draw.at('payoutReleased').content
      json.opening_date draw.at('openingDate').content
      json.closing_date draw.at('closingDate').content
      json.use_stake_based draw.at('useStakeBased').content
    end
  end
end
