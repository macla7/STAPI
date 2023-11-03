class Shift < ApplicationRecord
  has_many :posts
  belongs_to :bid, optional: true

  enum position: { AM: 0, PM: 1, Night: 2, Training: 3, Custom: 4 }
end
