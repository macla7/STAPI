class RemoveBidIdFromShifts < ActiveRecord::Migration[7.1]
  def change
    remove_reference :shifts, :bid, foreign_key: true
  end
end
