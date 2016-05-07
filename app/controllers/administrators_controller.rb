class AdministratorsController < ApplicationController
  before_filter :authenticate_administrator!
  before_filter :select_administrator_profile

  layout "administrator"

  def list
    @administration_menu_style = 'current'
    @create_administrator_account_menu_style = 'this'
    @users = Administrator.all.order("created_at DESC")
  end

  def disable_administrator_account
    user = Administrator.find_by_id(params[:administrator_id])

    if !user.blank?
      flash[:success] = "Le compte de #{user.full_name} a été désactivé."
      user.update_attributes(published: false)
    else
      flash[:error] = "Cet utilisateur n'existe pas."
    end

    redirect_to list_administrators_path
  end

  def enable_administrator_account
    user = Administrator.find_by_id(params[:administrator_id])

    if !user.blank?
      flash[:success] = "Le compte de #{user.full_name} a été activé."
      user.update_attributes(published: true)
    else
      flash[:error] = "Cet utilisateur n'existe pas."
    end

    redirect_to list_administrators_path
  end

  def edit_administrator
    @administration_menu_style = 'current'
    @create_administrator_account_menu_style = 'this'
    @administrator = Administrator.find_by_id(params[:administrator_id])

    if @administrator.blank?
      flash[:error] = "Cet utilisateur n'existe pas."
      redirect_to list_administrators_path
    else
      @profiles = Profile.all
    end
  end

  def delete_administrator
    @administrator = Administrator.find_by_id(params[:administrator_id])

    if @administrator.blank?
      flash[:error] = "Cet utilisateur n'existe pas."
    else
      if @administrator.id == current_administrator.id
        flash[:error] = "Vous ne pouvez pas supprimer votre compte."
      else
        @administrator.delete
        flash[:success] = "Le compte a été supprimé."
      end
    end

    redirect_to list_administrators_path
  end

  def update_administrator
    @administrator = Administrator.find_by_id(params[:id])

    if @administrator.blank?
      flash[:error] = "Ce compte n'existe pas"
      redirect_to list_administrators_path
    else
      @administrator.assign_attributes(params[:administrator])
      if @administrator.valid?
        @administrator.save
        flash[:success] = "Le compte a été mis à jour."
      else
        flash[:error] = @administrator.errors.full_messages.map { |msg| "#{msg}<br />" }.join
      end
      @profiles = Profile.all

      redirect_to edit_admin_path(@administrator.id)
    end
  end

  def roles_management
    @administrators = Administrator.all
    @profiles = Profile.all
    @administration_menu_style = 'current'
    @roles_management_menu_style = 'this'
  end

  def set_administrator_role
    administrator = Administrator.find_by_id(params[:administrator])
    profile = Profile.find_by_id(params[:profile])

    if administrator.blank? || profile.blank?
      flash[:error] = "Les paramètres sélectionnés ne sont pas valides"
    else
      administrator.update_attributes(profile_id: profile.id)
      flash[:success] = "Le compte et le profil ont été associés"
    end

    redirect_to roles_management_path
  end

end
