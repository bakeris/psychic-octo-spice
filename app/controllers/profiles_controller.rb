class ProfilesController < ApplicationController

  before_filter :authenticate_administrator!
  before_filter :select_administrator_profile
  before_filter :sign_out_disabled_users
  before_filter :init_administration_menu

  layout 'administrator'

  def index
    @create_profile_menu_style = 'this'
    @admin_profile = Profile.new
  end

  def create
    @admin_profile = Profile.new(params[:profile])

    if @admin_profile.save
      flash.now[:success] = "Le profil a été correctement créé."
      @admin_profile = Profile.new
    else
      flash[:error] = @admin_profile.errors.full_messages.map { |msg| "#{msg}<br />" }.join
    end

    render :index
  end

  def list
    @admin_profiles = Profile.all.order('description ASC')
  end

  def init_administration_menu
    @administration_menu_style = "current"
  end
end
