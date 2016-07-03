class QueryBetsController < ApplicationController

  def query_bet
    user = User.find_by_uuid(params[:uuid])

    if user.blank?
      @errors = "L'utilisateur n'a pas été trouvé"
    else

    end
  end

end
