class ProfilesController < ApplicationController

  before_filter :disconnect_profiless_users
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

  def profile_rights
    @admin_profile = Profile.find_by_id(params[:profile_id])

    if @admin_profile.blank?
      flash[:error] = "Ce profil n'existe pas"
      redirect_to list_profiles_path
    end
  end

  def enable_habilitation
    enable_disable_habilitation(params[:profile_id], true)
  end

  def disable_habilitation
    enable_disable_habilitation(params[:profile_id], false)
  end

  def enable_disable_habilitation(profile_id, status)
    @admin_profile = Profile.find_by_id(profile_id)

    if @admin_profile.blank?
      flash[:error] = "Ce profil n'existe pas"
      redirect_to :back
    else
      flash[:success] = "L'habilitation a été modifiée"
      @admin_profile.update_attributes(:"#{params[:habilitation]}" => status)

      redirect_to profile_rights_path(profile_id)
    end
  end

  def list
    @admin_profiles = Profile.all.order('description ASC')
  end

  def edit
    @profile = Profile.find_by_id(params[:profile_id])

    if @profile.blank?
      flash[:error] = "Ce profil n'existe pas"
      redirect_to :back
    end
  end

  def update
    @profile = Profile.find_by_id(params[:profile_id])

    if @profile.blank?
      flash[:error] = "Ce profil n'existe pas"
      redirect_to list_profiles_path
    else
      @profile.assign_attributes(params[:profile])
      if @profile.valid?
        @profile.save
        flash.now[:success] = "Le profil a été mis à jour."
      else
        flash.now[:error] = @profile.errors.full_messages.map { |msg| "#{msg}<br />" }.join
      end
      render :edit
    end
  end

  def delete
    @profile = Profile.find_by_id(params[:profile_id])

    if @profile.blank?
      flash[:error] = "Ce profil n'existe pas"
      redirect_to list_profiles_path
    else
      @profile.administrators.update_all(profile_id: nil) rescue nil
      @profile.delete
      flash[:success] = "Le profil a été supprimé"
    end

    redirect_to list_profiles_path
  end

  def init_administration_menu
    @administration_menu_style = "current"
  end
end
