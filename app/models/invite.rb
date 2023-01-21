class Invite < ApplicationRecord
  belongs_to :group
  belongs_to :internal_user, class_name: 'User', optional: true
  belongs_to :external_user, class_name: 'User', optional: true


  scope :accepted, -> { where accepted: true }
  scope :declined, -> { where accepted: false}
  scope :not_accepted, -> { where accepted: nil}
  
end