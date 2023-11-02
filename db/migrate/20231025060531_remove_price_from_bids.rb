class RemovePriceFromBids < ActiveRecord::Migration[7.0]
  def up
    remove_column :bids, :price
  end

  def down
    add_column :bids, :price, :bigint
  end
end
