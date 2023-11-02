class AddSolutionToPosts < ActiveRecord::Migration[7.0]
  def up
    add_column :posts, :solution, :integer, default: 0
  end

  def down
    remove_column :posts, :solution
  end
end
