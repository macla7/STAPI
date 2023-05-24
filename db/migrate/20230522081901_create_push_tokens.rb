class CreatePushTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :push_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :device_id, null: false, unique: true
      t.string :push_token, default: ""

      t.timestamps
    end
  end
end
