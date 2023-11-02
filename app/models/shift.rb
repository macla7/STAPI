class Shift < ApplicationRecord
  has_many :posts
  belongs_to :bid, optional: true  
end
