# app/controllers/members_controller.rb
module Api
  module V1
    module Users
      class Users::OmniauthCallbacksController < ApiController
        skip_before_action :doorkeeper_authorize!, only: %i[create]

        include DoorkeeperRegisterable
        include JsonWebToken
        # frozen_string_literal: true


        # You should configure your model like this:
        # devise :omniauthable, omniauth_providers: [:twitter]

        # You should also create an action method in this controller like this:
        # def twitter
        # end

        def google_oauth2
          user = User.from_omniauth(auth)

          # Commenting out as API --- MC
          # if user.present?
          #   sign_out_all_scopes
          #   flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
          #   sign_in_and_redirect user, event: :authentication
          # else
          #   flash[:alert] =
          #     t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
          #   redirect_to new_user_session_path
          # end

          if user.present?
            render json: render_user(find_user, client_app), status: :ok
          else
            render json: { errors: find_user.errors }, status: :unprocessable_entity
          end
        end

        # More info at:
        # https://github.com/heartcombo/devise#omniauth

        # GET|POST /resource/auth/twitter
        # def passthru
        #   super
        # end

        # GET|POST /users/auth/twitter/callback
        # def failure
        #   super
        # end

        # protected

        # The path used when OmniAuth fails
        # def after_omniauth_failure_path_for(scope)
        #   super(scope)
        # end

        protected

        # Commenting out as API --- MC
        # def after_omniauth_failure_path_for(_scope)
        #   new_user_session_path
        # end

        # Commenting out as API --- MC
        # def after_sign_in_path_for(resource_or_scope)
        #   stored_location_for(resource_or_scope) || root_path
        # end

        private

        # def from_google_params
        #   @from_google_params ||= {
        #     uid: auth.uid,
        #     email: auth.info.email,
        #     full_name: auth.info.name,
        #     avatar_url: auth.info.image
        #   }
        # end

        def auth
          @auth ||= request.env['omniauth.auth']
        end
      end
    end
  end
end