class AddAgeToInvitePerson < ActiveRecord::Migration[5.2]
  def change
    remove_column :invite_people, :child, :boolean
    add_column :invite_people, :age, :string
  end
end
