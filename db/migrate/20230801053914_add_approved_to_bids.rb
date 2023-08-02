class AddApprovedToBids < ActiveRecord::Migration[7.0]
  def change
    add_column :bids, :approved, :boolean, default: nil
  end
end
