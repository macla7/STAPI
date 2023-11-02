class RemoveShiftReferencesFromBids < ActiveRecord::Migration[7.0]
  def up
    remove_reference :bids, :shift, index: true
  end

  def down
    add_reference :bids, :shift, foreign_key: true
  end
end
