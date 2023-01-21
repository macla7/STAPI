class NotificationBlueprint < ApplicationRecord
  belongs_to :notificationable, :polymorphic => true
  has_many :notifications
  has_one :notification_origin

  include NotificationHelpers
end
