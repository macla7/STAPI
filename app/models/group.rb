class Group < ApplicationRecord
  extend SharedArrayMethods

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

  def data
    serializable_hash(methods: :number_of_memberships) 
  end

  # Behaviour in DTO?
  def number_of_memberships
    return self.memberships.length()
  end

  def users_not_in_group
    groups_users = self.users
    invited_users = self.invited_users
    all_users = User.all
    outside_group_users = (all_users - groups_users - invited_users)
    return outside_group_users
  end

end
