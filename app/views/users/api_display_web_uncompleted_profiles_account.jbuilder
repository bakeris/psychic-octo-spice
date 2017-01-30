json.user_type "WEB"
json.bets @users do |user|
  json.id user.id rescue nil
  json.uuid user.uuid rescue nil
  json.civility_id user.civility_id rescue nil
  json.sex_id user.sex_id rescue nil
  json.pseudo user.pseudo rescue nil
  json.firstname user.firstname rescue nil
  json.lastname user.lastname rescue nil
  json.email user.email rescue nil
  json.msisdn user.msisdn rescue nil
  json.birthdate user.birthdate rescue nil
  json.confirmed_at user.confirmed_at rescue nil
  json.paymoney_account user.paymoney_account rescue nil
end
