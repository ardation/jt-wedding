class MakeDefaultComingTrue < ActiveRecord::Migration[5.2]
  def up
    change_column :invite_people, :coming, :boolean, default: true
    Invite::Person.update_all(coming: true)
  end

  def down
    change_column :invite_people, :coming, :boolean, default: nil
  end
end
