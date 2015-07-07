class ResetPassword < ActionMailer::Base
  default from: "LONACI"

  def send_reset_password_email(email, reset_password_token)
    @email = email
    @reset_password_token = reset_password_token

    mail(to: @email, subject: "Réinitialisation du mot de passe de votre compte parieur")
  end
end
