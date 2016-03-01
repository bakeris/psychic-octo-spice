class UsersController < ApplicationController

  def api_create
    creation_mode = CreationMode.find_by_token(params[:creation_mode])

    if creation_mode.blank?
      render text: %Q({"errors":[{"message":"Vous n'avez pas pu être authentifié"}]})
    else
      if params[:password] != params[:password_confirmation]
        render text: %Q({"errors":[{"message":"Le mot de passe et sa confirmation ne concordent pas"}]})
      else
        @status = false
        @user = User.new(params.merge({creation_mode_id: creation_mode.id, salt: SecureRandom.base64(8).to_s, confirmation_token: SecureRandom.hex.to_s, uuid: SecureRandom.uuid}))

        if @user.save
          @status = true
          Thread.new do
            UserRegistration.confirmation_email(params[:firstname],params[:lastname], (Parameters.first.registration_url.to_s + @user.confirmation_token), params[:email]).deliver
          end
        end
      end
    end
  end

  def api_enable_account
    @user = User.find_by_confirmation_token(params[:confirmation_token])

    if @user.blank?
      render text: %Q({"errors":[{"message":"Cet utilisateur n'a pas été trouvé"}]})
    else
      if @user.confirmed_at.blank?
        @user.update_attribute(:confirmed_at, DateTime.now)
      else
        render text: %Q({"errors":[{"message":"Ce compte a déjà été activé"}]})
      end
    end
  end

  def api_reset_password
    @user = User.where("msisdn = '#{params[:parameter]}' OR id = #{params[:parameter].to_i} OR email = '#{params[:parameter]}'")

    if @user.blank?
      render text: %Q({"errors":[{"message":"Cet utilisateur n'a pas été trouvé"}]})
    else
      @user.first.update_attribute(:reset_password_token, SecureRandom.hex)
      ResetPassword.send_reset_password_email(@user.first.email, (Parameters.first.reset_password_url.to_s + @user.first.reset_password_token)).deliver
    end
  end

  def api_reset_password_activation
    @user = User.find_by_reset_password_token(params[:reset_password_token])
    password = params[:password]
    password_confirmation = params[:password_confirmation]

    if @user.blank?
      render text: %Q({"errors":[{"message":"Cet utilisateur n'a pas été trouvé"}]})
    else
      if password != password_confirmation
        render text: %Q({"errors":[{"message":"Le mot de passe et sa confirmation ne concordent pas"}]})
      else
        @user.update_attributes(reset_password_token: nil, password_reseted_at: DateTime.now, password: Digest::SHA2.hexdigest(@user.salt + password))
      end
    end
  end

  def api_update
    @user = User.find_by_id(params[:id])
    if @user.blank?
      render text: %Q({"errors":[{"message":"Cet utilisateur n'a pas été trouvé"}]})
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

      if @user.confirmed_at.blank?
        render text: %Q({"errors":[{"message":"Le compte n'a pas encore été activé"}]})
      else
        #if @user.login_status == "1"
          #render text: %Q({"errors":[{"message":"Ce compte est déjà connecté"}]})
        #else
          #@user.update_attributes(login_status: "1")
        #end
      end
    else
      render text: %Q({"errors":[{"message":"Veuillez vérifier le login et le mot de passe"}]})
    end
  end

  def api_msisdn_login
    if User.authenticate_with_msisdn(params[:msisdn], params[:password]) == true
      @user = User.find_by_msisdn(params[:msisdn])

      if @user.confirmed_at.blank?
        render text: %Q({"errors":[{"message":"Le compte n'a pas encore été activé"}]})
      else
        #if @user.login_status == "1"
          #render text: %Q({"errors":[{"message":"Ce compte est déjà connecté"}]})
        #else
          #@user.update_attributes(login_status: "1")
        #end
      end
    else
      render text: %Q({"errors":[{"message":"Veuillez vérifier le numéro de téléphone et le mot de passe"}]})
    end
  end

  def api_logout
    @user = User.where("email = '#{params[:connection_id]}' or msisdn = '#{params[:connection_id]}'").first rescue nil

    if @user.blank?
      render text: %Q({"errors":[{"message":"Cet utilisateur n'existe pas"}]})
    else
      @user.update_attributes(login_status: "0")
    end
  end

end
