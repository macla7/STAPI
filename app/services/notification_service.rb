# app/services/notification_service.rb
class NotificationService
  def initialize(post, current_user)
    @post = post
    @current_user = current_user
  end

  def create_and_schedule_notifications
    schedule_notification(11, 5.days) if @post.ends_at_more_than_duration_away?(5.days)
    schedule_notification(12, 3.days) if @post.ends_at_more_than_duration_away?(3.days)
    schedule_notification(13, 2.days) if @post.ends_at_more_than_duration_away?(2.days)
    schedule_notification(14, 1.day) if @post.ends_at_more_than_duration_away?(1.day)
    schedule_notification(15, 3.hours) if @post.ends_at_more_than_duration_away?(3.hours)
    schedule_notification(16, 1.hour) if @post.ends_at_more_than_duration_away?(1.hour)
  end

  private

  def schedule_notification(notification_type, duration)
    notification_blueprint = NotificationBlueprint.create(
      notificationable_type: 'Post',
      notificationable_id: @post.id,
      notification_type: notification_type,
    )
    SendNotificationBeforeEndJob.set(wait_until: @post.ends_at - duration).perform_later(notification_blueprint.id, @current_user.id)
  end
end
