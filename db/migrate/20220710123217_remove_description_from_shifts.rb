class RemoveDescriptionFromShifts < ActiveRecord::Migration[7.0]
  def change
    remove_column :shifts, :description, :text
  end
end
