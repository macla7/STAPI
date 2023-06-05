class Membership < ApplicationRecord
  extend SharedArrayMethods
  
  belongs_to :user
  belongs_to :group

  scope :is_admin, -> { where(role: 'admin') }

  enum status: [:current, :left, :kicked]
  enum role: [:admin, :user]

  # TODO: No way to be readded with this here and current db. also no way to kick anyway.
  validates :user_id, uniqueness: { scope: :group,
    message: "A User can only have one membership per group" }

  def data
    serializable_hash(include: [user: {methods: :avatar_url}]) 
  end
  
end
