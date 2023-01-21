class NotificationOrigin < ApplicationRecord
  belongs_to :notification_blueprint
  belongs_to :notifier, class_name: 'User', foreign_key: 'notifier_id'
end
