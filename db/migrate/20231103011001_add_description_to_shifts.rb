class AddDescriptionToShifts < ActiveRecord::Migration[7.1]
  def change
    add_column :shifts, :description, :text
  end
end
