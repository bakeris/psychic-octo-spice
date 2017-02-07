if @status
  json.user do
    json.id @user.id rescue nil
    json.uuid @user.uuid rescue nil
    json.civility_id @user.civility_id rescue nil
    json.sex_id @user.sex_id rescue nil
    json.pseudo @user.pseudo rescue nil
    json.firstname @user.firstname rescue nil
    json.lastname @user.lastname rescue nil
    json.email @user.email rescue nil
    json.msisdn @user.msisdn rescue nil
    json.birthdate @user.birthdate rescue nil
    json.confirmed_at @user.confirmed_at rescue nil
    json.login_status @user.login_status rescue nil
    json.paymoney_account @user.paymoney_account rescue nil
    json.profile_completed (@user.firstname != "Parionsdirect" && @user.lastname != "Parionsdirect" && @user.email[0..3] != "ussd") ? "true" : "false"
  end
else
  json.errors @user.errors.full_messages.map do |error|
    json.message error
  end
end
