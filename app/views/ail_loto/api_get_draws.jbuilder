if @error_code != 0
  json.error code: @error_code, description: @error_description
else
  json.game "LOTO"
  json.draws @draws_list do |draw|
    json.id draw["drawID"] rescue nil
    json.state draw["drawState"] rescue nil
    json.number_of_entries draw["numberOfEntries"] rescue nil
    json.opening_date draw["openingDate"] rescue nil
    json.closing_date draw["closingDate"] rescue nil
    json.selector1 draw["selector1"] rescue nil
    json.selector2 draw["selector2"] rescue nil
    json.payouts_released draw["payoutsReleased"] rescue nil
    json.use_stake_based draw["useStakeBased"] rescue nil
  end
end
