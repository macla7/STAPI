class Notification < ApplicationRecord
  extend SharedArrayMethods

  belongs_to :notification_blueprint
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'

  default_scope { order(created_at: :desc) }

  include NotificationsHelper

  def data
    # I'm not sure if these are 'train wrecks' as their DTO's.. perhaps getting notifier_avatar_url is knowing too
    # much 'behaviour' from a object two away.. Yet these DTO's are natually heavily coupled.. so I don't think
    # it's a big deal. avatar_url is more akin to data retrieval than behaviour anyway I reckon..
    self.as_json.merge({
      notification_blueprint: self.notification_blueprint,
      notification_origin: self.notification_blueprint.notification_origin,
      description: make_notification_description(self.notification_blueprint, self.notification_blueprint.notification_origin),
      group_id: get_group(self.notification_blueprint),
      notifier_avatar_url: self.notification_blueprint.notification_origin.avatar_url
      })
  end

end
