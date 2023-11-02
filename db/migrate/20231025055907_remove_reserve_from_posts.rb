class RemoveReserveFromPosts < ActiveRecord::Migration[7.0]
  def up
    remove_column :posts, :reserve
  end

  def down
    add_column :posts, :reserve, :bigint
  end
end
