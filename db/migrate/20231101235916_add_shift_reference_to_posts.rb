class AddShiftReferenceToPosts < ActiveRecord::Migration[7.0]
  def up
    add_reference :posts, :shift, foreign_key: true
  end

  def down
    remove_reference :posts, :shift
  end

end
