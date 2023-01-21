class CreateNotificationBlueprints < ActiveRecord::Migration[7.0]
  def change
    create_table :notification_blueprints do |t|
      t.references :notificationable, polymorphic: true
      t.integer :notification_type

      t.timestamps
    end
  end
end
