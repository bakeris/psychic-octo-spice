if @status
  json.user @user, :id, :uuid, :civility_id, :sex_id, :pseudo, :firstname, :lastname, :email, :msisdn, :birthdate, :confirmed_at, :paymoney_account
else
  json.errors @user.errors.full_messages.map do |error|
    json.message error
  end
end
