class Bid < ApplicationRecord
  include ActiveModel::Serializers::JSON
  
  belongs_to :post
  belongs_to :user

  default_scope { order(price: :desc) }

  def avatar_url
    return self.user.avatar_url
  end

  def bidder
    return self.user.name
  end
end
