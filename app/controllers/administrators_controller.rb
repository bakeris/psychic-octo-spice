class AdministratorsController < ApplicationController
  before_filter :authenticate_administrator!

  layout "administrator"

  def list
    @users = Administrator.all.order("created_at DESC")
  end

end
