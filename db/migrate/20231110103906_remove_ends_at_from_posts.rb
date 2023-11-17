class RemoveEndsAtFromPosts < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :ends_at, :datetime
  end

end
