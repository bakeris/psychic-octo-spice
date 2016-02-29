class GamersController < ApplicationController

  layout "administrator"

  def index
    @class_gamers = "active"
    @gamers = User.all.order("created_at DESC")
  end

end
