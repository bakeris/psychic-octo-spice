class WinningNotification < ActionMailer::Base
  default from: "serviceclients@parionsdirect.net"

  def notification_email(user, amount, game_object, game_message, ticket_id, paymoney_account_number, ref_number)
    @user_name = (user.firstname rescue "") + " " + (user.lastname rescue "")
    @amount = amount
    @game_object = game_object
    @game_message = game_message
    @ticket_id = ticket_id
    @paymoney_account_number = paymoney_account_number
    @ref_number = ref_number
    @sill_amount = Parameter.first.sill_amount rescue 0

    mail(to: user.email, subject: "Vous avez gagné #{@game_object}")
  end
end
