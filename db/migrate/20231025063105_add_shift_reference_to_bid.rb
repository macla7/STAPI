class AddShiftReferenceToBid < ActiveRecord::Migration[7.0]
  def change
    add_reference :bids, :shift, foreign_key: true
  end
end
