# This whole file makes me uncomfortable lol
module NotificationHelpers
  extend ActiveSupport::Concern

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
      return "#{notification_origin.notifier.email} invited you to #{@group.name}"
    when 3
      return "#{notification_origin.notifier.email} has requested to join #{@group.name}"
    when 4
      return "#{notification_origin.notifier.email} posted in #{@group.name}"
    when 5
      return "#{notification_origin.notifier.email} bid on your Post"
    when 6
      return "#{notification_origin.notifier.email} bid on a Post you've bid on"
    when 7
      return "#{notification_origin.notifier.email} liked your Post"
    when 8
      return "#{notification_origin.notifier.email} commented on your Post"
    when 9
      return "#{notification_origin.notifier.email} commented on a Post you've commented on"
    else 
      return "Error, can't find this notification.."
    end
  end

  def getRecipients(notification_blueprint_params, current_user)
    set_entity(notification_blueprint_params['notificationable_type'], notification_blueprint_params['notificationable_id'])
    p 'in notification helper, entity is'
    p @group
    p 'post is'
    p @post
    p 'current user is'
    p current_user
    case notification_blueprint_params['notification_type']
    when 1
      return [User.find(notification_blueprint_params['recipient_id'])]
    when 3
      return @group.admins
    when 4
      return @group.users.distinct.where.not(id: current_user.id)
    when 5, 7, 8
      return [@post.user]
    when 6
      return @post.bidding_users.distinct.where.not(id: current_user.id)
    when 9
      return @post.commenting_users.distinct.where.not(id: current_user.id)
    else
      return []
    end
  end
end