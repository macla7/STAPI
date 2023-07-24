require 'exponent-server-sdk'

class Api::V1::NotificationBlueprintsController < ApiController

  include NotificationsHelper

  before_action :set_notification_blueprint, only: %i[ show edit update destroy ]

  # POST /notification_blueprints or /notification_blueprints.json
  def create
    @notification_blueprint = NotificationBlueprint.new(notification_blueprint_params.slice(
      :notificationable_type, :notificationable_id, :notification_type
    ))

    respond_to do |format|
      if @notification_blueprint.save!
        send_push_notification(@notification_blueprint, current_user, notification_blueprint_params['recipient_id'] ? notification_blueprint_params['recipient_id'] : nil )
        format.json { render json: @notification_blueprint, status: :ok }
      else
        format.json { render json: @notification_blueprint.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification_blueprint
      @notification_blueprint = NotificationBlueprint.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notification_blueprint_params
      params.require(:notification_blueprint).permit(
        :notificationable_type, :notificationable_id, :notification_type, :recipient_id
      )
    end

    def broadcast notification
      recipient = User.find(notification.recipient_id)
      NotificationsChannel.broadcast_to(recipient, notification.data)
    end
end
