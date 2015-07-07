class UserRegistration < ActionMailer::Base
  default from: "LONACI"

  def confirmation_email(email, confirmation_token)
    @email = email
    @confirmation_token = confirmation_token

    mail(to: @email, subject: "Activation de votre compte parieur")
  end
end
