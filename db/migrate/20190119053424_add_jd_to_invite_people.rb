class AddJdToInvitePeople < ActiveRecord::Migration[5.2]
  def change
    add_column :invite_people, :job_title, :string
    add_column :invite_people, :job_url, :string
  end
end
