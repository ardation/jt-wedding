class AddRsvpToInvites < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :rsvp, :boolean, default: false
  end
end
