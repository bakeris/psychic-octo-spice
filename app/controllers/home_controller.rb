class HomeController < ApplicationController
  before_filter :disconnect_profiless_users
  before_filter :authenticate_administrator!
  before_filter :select_administrator_profile
  before_filter :sign_out_disabled_users

  layout "administrator"

  def index

  end
end
