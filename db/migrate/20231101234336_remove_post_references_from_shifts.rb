class RemovePostReferencesFromShifts < ActiveRecord::Migration[7.0]
  def up
    remove_reference :shifts, :post, index: true
  end

  def down
    add_reference :shifts, :post, foreign_key: true
  end

end
