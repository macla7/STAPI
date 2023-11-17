class AddUserToShifts < ActiveRecord::Migration[7.1]
  def change
    add_reference :shifts, :user, null: false, foreign_key: true
  end
end
