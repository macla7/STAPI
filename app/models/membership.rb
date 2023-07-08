class Membership < ApplicationRecord
  extend SharedArrayMethods
  
  belongs_to :user
  belongs_to :group

  scope :is_admin, -> { where(role: 'admin') }
  scope :is_active, -> { where(status: 'current') }

  enum status: [:current, :left, :kicked]
  enum role: [:admin, :user]

  # TODO: No way to be readded with this here and current db. also no way to kick anyway.
  validates :user_id, uniqueness: { scope: [:group_id, :status],
    conditions: -> { where(status: :current) },
    message: "A user can only have one current membership per group" }

  default_scope { order(role: :asc) }

  def data
    serializable_hash(include: [user: {methods: :avatar_url}]) 
  end
  
end
