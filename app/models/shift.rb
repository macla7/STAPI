class Shift < ApplicationRecord
  include ActiveModel::Serializers::JSON
    

  belongs_to :post
end
