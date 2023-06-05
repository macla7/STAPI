class Api::V1::Users::PasswordsController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      render json: { emailValidity: true}
    else
      render json: { emailValidity: false}
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
    token = Devise.token_generator.digest(User, :reset_password_token, params['reset_password_token'])
    user = User.find_by(reset_password_token: token)
    respond_to do |format|
      if user.present?
        format.json { render json: {tokenValidity: true}, status: :ok }
      else
        format.json { render json: {tokenValidity: false}, status: :unprocessable_entity }
      end
    end
  end

  # GET /resource/password/token
  # def check_token
  #   token = Devise.token_generator.digest(User, :reset_password_token, params['reset_password_token'])
  #   user = User.find_by(reset_password_token: token)
  #   respond_to do |format|
  #     if user.present?
  #       format.json { render json: true, status: :ok }
  #     else
  #       format.json { render json: false, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    respond_to do |format|
      # TODO: Would this be where i put some DB protections on password..?
      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        # TODO: Not fully accross what's going on in this if...
        if Devise.sign_in_after_reset_password
          flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
          format.json { render json: {passwordValidity: true, flash_message: {password: [flash_message]}, email: resource.email}, status: :ok }
        else
          format.json { render json: {passwordValidity: true, flash_message: {password: [:updated_not_active]}}, status: :ok }
        end
      else
        format.json { render json: {passwordValidity: false, flash_message: resource.errors}, status: :unprocessable_entity }
      end
    end
  end

  protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end
end
