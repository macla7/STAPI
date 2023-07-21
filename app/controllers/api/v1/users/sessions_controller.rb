# app/controllers/members_controller.rb
module Api
  module V1
    module Users
      class SessionsController < ApiController
        skip_before_action :doorkeeper_authorize!, only: %i[create]

        include DoorkeeperRegisterable
        include JsonWebToken

        def create
          client_app = Doorkeeper::Application.find_by(uid: user_params[:client_id])
          unless client_app
            return render json: {error: I18n.t('doorkeeper.errors.messages.invalid_client')},
            status: :unauthorized
          end

          find_user = User.where("email = ?", params["email"]).first

          if find_user.nil?
            render json: { valid_email: false }, status: :unprocessable_entity
          elsif find_user.valid_password?(params["password"])
            render json: render_user(find_user, client_app), status: :ok
          else
            render json: { valid_password: find_user.valid_password?(params["password"]) }, status: :unprocessable_entity
          end
        end

        # '/session-data/with-token'
        def show
          client_app = Doorkeeper::Application.find_by(uid: user_params[:client_id])
          unless client_app
            return render json: {error: I18n.t('doorkeeper.errors.messages.invalid_client')},
            status: :unauthorized
          end

          jwt_decoded = jwt_decode(request.headers['Authorization'])[0]
          find_user = User.where("email = ?", jwt_decoded["user"]['email']).first

          render json: render_user(find_user, client_app), status: :ok
        end

        private

        def user_params
          params.require(:session).permit(:email, :password, :client_id, :grant_type, :client_secret, :session)
        end
      end
    end
  end
end