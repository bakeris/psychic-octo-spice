class ResetPassword < ActionMailer::Base
  default from: "serviceclients@parionsdirect.net"

  def send_reset_password_email(email, reset_password_url)
    @email = email
    @reset_password_url = reset_password_url

    mail(to: @email, subject: "Réinitialisation du mot de passe de votre compte parieur")
  end
end
