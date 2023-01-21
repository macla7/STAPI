class Post < ApplicationRecord
  include ActiveModel::Serializers::JSON
  belongs_to :user
  belongs_to :group
  has_many :likes, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  has_many :shifts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :notification_blueprints, :as => :notificationable
  has_many :bidding_users, through: :bids, source: :user
  has_many :commenting_users, through: :comments, source: :user
  
  accepts_nested_attributes_for :shifts
  
  scope :active, ->{ where('ends_at > ?', DateTime.current()) }
  scope :past_posts, ->{ where('ends_at < ?', DateTime.current())}

  def post_info
    serializable_hash(include: [:shifts, :likes, comments: {methods: [:avatar_url, :commentor]}, bids: {methods: [:avatar_url, :biddor]}], methods: [:group_name, :postor_name, :avatar_url]) 
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
    serializable_hash(include: [bids: {methods: [:avatar_url, :biddor]}]) 
  end

  def comments_with_avatars
    serializable_hash(include: [comments: {methods: [:avatar_url, :commentor]}]) 
  end

end
