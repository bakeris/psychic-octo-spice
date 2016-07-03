if !@error_code.blank?
  json.error code: @error_code, description: @error_description
else
  json.bet do
    json.bet_id @bet_id
    json.name @name
    json.mnemonic @mnemonic
    json.unit @unit
    json.max_nb_units @max_nb_units
    json.full_boxing @full_boxing
    json.full_box_name @full_box_name
    json.full_boxing @full_boxing
    json.formulas @bet_formulas
  end
end
