class Notification < ApplicationRecord
  belongs_to :notification_blueprint
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'

  default_scope { order(created_at: :desc) }

  include NotificationHelpers

  def notification_info
    self.as_json.merge({
      notification_blueprint: self.notification_blueprint,
      notification_origin: self.notification_blueprint.notification_origin,
      description: make_notification_description(self.notification_blueprint, self.notification_blueprint.notification_origin),
      group_id: get_group(self.notification_blueprint)
      })  
  end

end
