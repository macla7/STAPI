class CreateNotificationOrigins < ActiveRecord::Migration[7.0]
  def change
    create_table :notification_origins do |t|
      t.references :notification_blueprint, null: false, foreign_key: true
      t.references :notifier, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
