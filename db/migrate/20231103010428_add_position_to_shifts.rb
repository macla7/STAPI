class AddPositionToShifts < ActiveRecord::Migration[7.1]
  def change
    add_column :shifts, :position, :integer
  end
end
