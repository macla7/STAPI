class AddReserveToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :reserve, :bigint
  end
end
