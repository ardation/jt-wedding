class AddUserToInvites < ActiveRecord::Migration[5.2]
  def change
    add_reference :invites, :admin_user, foreign_key: { on_delete: :nullify }
  end
end
