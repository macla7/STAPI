class RemovePositionFromShifts < ActiveRecord::Migration[7.1]
  def change
    remove_column :shifts, :position, :string
  end
end
