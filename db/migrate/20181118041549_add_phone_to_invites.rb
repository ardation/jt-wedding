class AddPhoneToInvites < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :phone, :string
  end
end
