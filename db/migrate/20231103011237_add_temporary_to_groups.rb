class AddTemporaryToGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :groups, :temporary, :boolean, default: true
  end
end
