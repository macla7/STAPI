class Group < ApplicationRecord
  has_many :memberships, :dependent => :destroy
  has_many :users, through: :memberships
  has_many :requests, -> { where request: true }, class_name: 'Invite'
  has_many :posts
  has_many :notification_blueprints, :as => :notificationable
  has_many :invites, -> { where request: false, accepted: nil }, class_name: 'Invite'
  has_many :invited_users, through: :invites, source: :external_user, class_name: 'User'

  def admins
    return memberships.is_admin.map { |member| member.user}
  end

  def group_info
    serializable_hash(methods: :number_of_memberships) 
  end

  def number_of_memberships
    return self.memberships.length()
  end
  
end
