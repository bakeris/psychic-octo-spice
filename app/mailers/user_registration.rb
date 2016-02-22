class UserRegistration < ActionMailer::Base
  default from: "serviceclients@parionsdirect.net"

  def confirmation_email(firstname, lastname, confirmation_url, email)
    @firstname = firstname
    @lastname = lastname
    @confirmation_url = confirmation_url
    @email = email

    mail(to: @email, subject: "Activation de votre compte parieur")
  end
end
