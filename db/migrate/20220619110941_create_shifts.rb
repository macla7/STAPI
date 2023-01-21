class CreateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :shifts do |t|
      t.string :position
      t.text :description
      t.datetime :start
      t.datetime :end
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
