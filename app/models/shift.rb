class Shift < ApplicationRecord
  has_many :posts
  has_many :bids
  belongs_to :user

  enum position: { AM: 0, PM: 1, Night: 2, Training: 3, Custom: 4, Off: 5 }

  def owner_name
    self.user.name
  end

  def avatar_url
    self.user.avatar_url
  end
end
