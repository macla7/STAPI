class User < ApplicationRecord
  extend SharedArrayMethods
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :omniauthable, :validatable,
         :jwt_authenticatable, :recoverable, 
         jwt_revocation_strategy: JwtDenylist,
         omniauth_providers: [:google_oauth2]
         
         # :rememberable

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :name, presence: true, allow_blank: false
  
  enum role: %i[user admin]

  has_one_attached :avatar

  has_many :posts
  has_many :memberships
  has_many :groups, through: :memberships
  has_many :current_groups, -> { where(memberships: { status: :current }) }, through: :memberships, source: :group
  has_many :requests, -> { where request: true}, class_name: 'Invite', foreign_key: 'external_user'
  has_many :invites, -> { where request: false }, class_name: 'Invite', foreign_key: 'external_user'
  has_many :sent_invites, -> { where request: false }, class_name: 'Invite', foreign_key: 'internal_user'
  has_many :likes
  has_many :bids
  has_many :comments
  has_many :notifications, -> { where actioned: nil }, foreign_key: 'recipient_id'
  has_many :notification_origins, foreign_key: 'notifier_id'
  has_many :push_tokens

  after_commit :add_default_avatar, on: %i[create update]

  before_create :create_confirmation_token_if_blank

  # # Not tested
  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0, 20]
  #     user.full_name = auth.info.name # assuming the user model has a name
  #     # user.avatar_url = auth.info.image # assuming the user model has an image
  #     # If you are using confirmable and the provider(s) you use validate emails,
  #     # uncomment the line below to skip the confirmation emails.
  #     # user.skip_confirmation!
  #   end
  # end

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  def avatar_url
    unless avatar.attached?
      add_default_avatar
    end

    return Rails.application.routes.url_helpers.url_for(avatar) 
  end

  def add_default_avatar
    return if avatar.attached?
    
    avatar.attach(
      io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar_3.png')),
      filename: 'default_avatar_3.png',
      content_type: 'image/png'
    )
  end

  def data
    serializable_hash(methods: :avatar_url)
  end

  def create_confirmation_token_if_blank
    if self.confirm_token.blank?
        self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

  def authenticated_email
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  def not_in_groups
    userInGroups = self.current_groups
    allGroups = Group.all
    otherGroups = Group.where(id: (allGroups - userInGroups).map(&:id)) 
    return otherGroups
  end

  def available_groups
    Group.where.not(id: current_groups.pluck(:id))
  end

  def requests_and_invites_pending
    # Retrieve groups the user has been invited to
    invited_groups = Invite.where(external_user: self, request: false, accepted: nil)

    # Retrieve groups the user has requested to join
    requested_groups = Invite.where(external_user: self, request: true, accepted: nil)

    invited_groups + requested_groups
  end
end
