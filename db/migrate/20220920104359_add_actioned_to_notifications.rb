class AddActionedToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :actioned, :boolean
  end
end
