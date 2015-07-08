class UserRegistration < ActionMailer::Base
  default from: "LONACI"

  def confirmation_email(email, confirmation_url)
    @email = email
    @confirmation_url = confirmation_url

    mail(to: @email, subject: "Activation de votre compte parieur")
  end
end
