class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  scope :is_admin, -> { where(role: 'admin') }

  enum status: [:current, :left, :kicked]
  enum role: [:admin, :user]

  validates :user_id, uniqueness: { scope: :group,
    message: "A User can only have one membership per group" }

  def member_info
    serializable_hash(include: [user: {methods: :avatar_url}]) 
  end
end
