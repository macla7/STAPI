module NotificationsHelper
  def set_entity(notificationable_type, notificationable_id)
    if notificationable_type == "Invite"
      @invite = Invite.find(notificationable_id)
      @group =  Group.find(@invite.group_id)
    elsif notificationable_type == "Post"
      @post = Post.find(notificationable_id)
      @group =  Group.find(@post.group_id)
    end
  end

  def get_group(notification_blueprint)
    set_entity(notification_blueprint.notificationable_type, notification_blueprint.notificationable_id)
    return @group.id
  end

  def make_notification_description(notification_blueprint, notification_origin)
    set_entity(notification_blueprint.notificationable_type, notification_blueprint.notificationable_id)
    case notification_blueprint.notification_type
    when 1
      return "#{notification_origin.notifier.name} invited you to #{@group.name}"
    when 3
      return "#{notification_origin.notifier.name} has requested to join #{@group.name}"
    when 4
      return "#{notification_origin.notifier.name} posted in #{@group.name}"
    when 5
      return "#{notification_origin.notifier.name} bid on your Post"
    when 6
      return "#{notification_origin.notifier.name} bid on a Post you've bid on"
    when 7
      return "#{notification_origin.notifier.name} liked your Post"
    when 8
      return "#{notification_origin.notifier.name} commented on your Post"
    when 9
      return "#{notification_origin.notifier.name} commented on a Post you've commented on"
    when 10
      return "#{notification_origin.notifier.name}'s post has ended. Please Approve any Bids."
    when 11
      return "#{notification_origin.notifier.name}'s post ends in 5 days"
    when 12
      return "#{notification_origin.notifier.name}'s post ends in 3 days"
    when 13
      return "#{notification_origin.notifier.name}'s post ends in 2 days"
    when 14
      return "#{notification_origin.notifier.name}'s post ends in 1 day"
    when 15
      return "#{notification_origin.notifier.name}'s post ends in 3 hours"
    when 16
      return "#{notification_origin.notifier.name}'s post ends in 1 hour"
    else 
      return "Error, can't find this notification.."
    end
  end

  def getRecipients(notification_blueprint, current_user, recipient_id = nil)
    set_entity(notification_blueprint['notificationable_type'], notification_blueprint['notificationable_id'])
    case notification_blueprint['notification_type']
    when 1
      return [User.find(recipient_id)]
    when 3
      return @group.admins
    when 4, 11, 12, 13, 14, 15
      return @group.users.where.not(id: current_user.id)
    when 5, 7, 8
      return [@post.user]
    when 6
      return @post.unique_bidding_users.where.not(id: current_user.id)
    when 9
      return @post.unique_commenting_users.where.not(id: current_user.id)
    else
      return []
    end
  end

  def send_push_notification(notification_blueprint, current_user, recipient_id = nil)
    notification_origin = current_user.notification_origins.create(notification_blueprint_id: notification_blueprint.id)

    getRecipients(notification_blueprint, current_user, recipient_id).each do |recipient|
      notification = Notification.create(recipient_id: recipient.id, notification_blueprint_id: notification_blueprint.id)

      # expo_push_notification_service = ExpoPushNotificationService.new(recipient)
      # expo_push_notification_service.send_notifications(make_notification_description(@notification_blueprint, @notification_origin))
      broadcast notification

      
      if recipient.push_tokens.length > 0
        client = Exponent::Push::Client.new
        messages = [{
          to: recipient.push_tokens.last.push_token,
          sound: "default",
          body: make_notification_description(notification_blueprint, notification_origin)
        }]
        handler = client.send_messages(messages)
      end
    end
  end

    def broadcast notification
      recipient = User.find(notification.recipient_id)
      NotificationsChannel.broadcast_to(recipient, notification.data)
    end
end
