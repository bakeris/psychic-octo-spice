class AdministratorsController < ApplicationController
  before_filter :authenticate_administrator!
  before_filter :select_administrator_profile

  layout "administrator"

  def list
    @users = Administrator.all.order("created_at DESC")
  end

end
