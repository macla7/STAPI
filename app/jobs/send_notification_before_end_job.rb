# app/jobs/send_notification_before_end_job.rb
class SendNotificationBeforeEndJob < ApplicationJob
  include NotificationsHelper

  def perform(notification_blueprint_id, current_user_id)
    # Find the notification_blueprint using the provided id
    notification_blueprint = NotificationBlueprint.find_by(id: notification_blueprint_id)

    return unless notification_blueprint

    # Determine the current_user based on the provided current_user_id
    current_user = User.find_by(id: current_user_id)

    return unless current_user

    # Call the send_push_notification method
    send_push_notification(notification_blueprint, current_user, nil)
  end

end

