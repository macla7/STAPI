class AddSwappingToShifts < ActiveRecord::Migration[7.1]
  def change
    add_column :shifts, :status, :integer, default: 0 # Assuming 'no' is 0
  end

end
