class CreateAppVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :app_versions do |t|
      t.string :version

      t.timestamps
    end
  end
end
