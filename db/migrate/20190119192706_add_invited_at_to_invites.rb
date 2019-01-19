class AddInvitedAtToInvites < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :invited_at, :timestamp
  end
end
