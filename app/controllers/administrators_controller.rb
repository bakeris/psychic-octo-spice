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

end
