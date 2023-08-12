class AddHideToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :hide, :boolean, default: false
  end
end
