class NotificationBlueprint < ApplicationRecord
  belongs_to :notificationable, :polymorphic => true
  has_many :notifications, dependent: :destroy
  has_one :notification_origin, dependent: :destroy
end
