class AddBidReferenceToShift < ActiveRecord::Migration[7.0]
  def change
    add_reference :shifts, :bid, foreign_key: true
  end
end
