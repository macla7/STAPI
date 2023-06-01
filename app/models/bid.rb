class Bid < ApplicationRecord
  belongs_to :post
  belongs_to :user

  default_scope { order(price: :desc) }

  def avatar_url
    return self.user.avatar_url
  end

  def bidder_name
    return self.user.name
  end
end
