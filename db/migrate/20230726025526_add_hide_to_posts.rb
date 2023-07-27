class AddHideToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :hide, :boolean, default: false
  end
end
