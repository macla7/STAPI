class Post < ApplicationRecord
  extend SharedArrayMethods

  default_scope { order(created_at: :desc) }

  belongs_to :user
  belongs_to :group, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  # has_many :shifts, :dependent => :destroy
  belongs_to :shift, optional: true  
  has_many :comments, -> { where(hide: false) }, class_name: 'Comment', dependent: :destroy
  has_many :notification_blueprints, :as => :notificationable
  has_many :bidding_users, through: :bids, source: :user
  has_many :commenting_users, through: :comments, source: :user
  
  accepts_nested_attributes_for :shift
  
  scope :active, ->{ where('ends_at > ?', DateTime.current()) }
  scope :past_posts, ->{ where('ends_at < ?', DateTime.current())}
  scope :live_posts, -> { where('hide = ? OR hide IS NULL', false) }

  enum solution: [:swap, :cover, :either]

  def data
    serializable_hash(include: [:likes, shift: {methods: [:owner_name, :avatar_url]}, comments: {methods: [:avatar_url, :commentor_name]}, bids: {methods: [:shift_bidded, :avatar_url, :bidder_name]}], methods: [:group_name, :postor_name, :avatar_url, :post_admins]) 
  end

  def group_name
    return self.group.name
  end

  def postor_name
    self.user.name
  end

  def avatar_url
    self.user.avatar_url
  end

  def bids_with_avatars
    serializable_hash(include: [bids: {methods: [:avatar_url, :bidder_name]}]) 
  end

  def comments_with_avatars
    serializable_hash(include: [comments: {methods: [:avatar_url, :commentor_name]}]) 
  end

  def unique_bidding_users
    user_ids = bids.select('DISTINCT user_id').pluck(:user_id)
    User.where(id: user_ids)
  end

  def unique_commenting_users
    user_ids = comments.select('DISTINCT user_id').pluck(:user_id)
    User.where(id: user_ids)
  end

  def post_admins
    group.admins
  end

  # def ends_at_more_than_duration_away?(duration)
  #   return false unless ends_at.present?

  #   ends_at > duration.from_now
  # end
 
end
