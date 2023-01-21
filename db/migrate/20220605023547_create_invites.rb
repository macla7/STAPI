class CreateInvites < ActiveRecord::Migration[7.0]
  def change
    create_table :invites do |t|
      t.references :group, null: false, foreign_key: true
      t.references :internal_user, foreign_key: { to_table: :users }
      t.references :external_user, foreign_key: { to_table: :users }
      t.boolean :request, null: false
      t.boolean :accepeted

      t.timestamps
    end
  end
end
