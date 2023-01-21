class ChangeInvitesTableAccepted < ActiveRecord::Migration[7.0]
  change_table :invites do |t|
    t.rename :accepeted, :accepted
  end
end
