class AdministratorsController < ApplicationController

  layout "administrator"

  def list
    @users = Administrator.all.order("created_at DESC")
  end

end
