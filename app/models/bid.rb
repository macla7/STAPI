class Bid < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :shift

  # default_scope { order(price: :desc) }

  def avatar_url
    return self.user.avatar_url
  end

  def bidder_name
    return self.user.name
  end

  def shift_bidded
    return self.shift
  end
end
