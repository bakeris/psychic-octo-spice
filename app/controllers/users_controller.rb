class UsersController < ApplicationController

  def api_create
    creation_mode = CreationMode.find_by_token(params[:creation_mode])

    if creation_mode.blank?
      render text: %Q[{"errors":"Vous n'avez pas pu être authentifié"}]
    else
      if params[:password] != params[:password_confirmation]
        render text: %Q[{"errors":"Le mot de passe et sa confirmation ne concordent pas"}]
      else
        @status = false
        @user = User.new(params.merge({:creation_mode_id => creation_mode.id}).merge({:salt => SecureRandom.base64(8).to_s}))

        if @user.save
          @status = true
        end
      end
    end
  end

  def api_update
    @user = User.find_by_id(params[:id])
    if @user.blank?
      render text: %Q[{"errors":"Cet utilisateur n'a pas été trouvé"}]
    else
      @status = false
      @user.update_attributes(params)
      if @user.errors.full_messages.blank?
        @status = true
      end
    end
  end

  def api_email_login
    if User.authenticate_with_email(params[:email], params[:password]) == true
      @user = User.find_by_email(params[:email])
    else
      render text: %Q[{"errors":"Veuillez vérifier le login et le mot de passe"}]
    end
  end

  def api_msisdn_login
    if User.authenticate_with_msisdn(params[:msisdn], params[:password]) == true
      @user = User.find_by_msisdn(params[:msisdn])
    else
      render text: %Q[{"errors":"Veuillez vérifier le numéro de téléphone et le mot de passe"}]
    end
  end

end
