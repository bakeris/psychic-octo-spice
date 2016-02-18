class WinningNotification < ActionMailer::Base
  default from: "LONACI"

  def notification_email(user, amount, game_object, game_message, ticket_id)
    @user_name = (user.firstname rescue "") + " " + (user.lastname rescue "")
    @amount = amount
    @game_object = game_object
    @game_message = game_message
    @ticket_id = ticket_id

    mail(to: user.email, subject: "Vous avez gagné #{@game_object}")
  end
end
