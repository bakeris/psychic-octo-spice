class WinningNotification < ActionMailer::Base
  default from: "serviceclients@parionsdirect.net"

  def notification_email(user, amount, game_object, game_message, ticket_id, paymoney_account_number)
    @user_name = (user.firstname rescue "") + " " + (user.lastname rescue "")
    @amount = amount
    @game_object = game_object
    @game_message = game_message
    @ticket_id = ticket_id
    @paymoney_account_number = paymoney_account_number

    mail(to: user.email, subject: "Vous avez gagné #{@game_object}")
  end
end
