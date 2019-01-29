class AddComingReceptionToInvitePeople < ActiveRecord::Migration[5.2]
  def change
    add_column :invite_people, :coming_reception, :boolean, default: true
  end
end
