class UpdateJobRelationshipOnPeople < ActiveRecord::Migration[5.2]
  def change
    remove_column :invite_people, :job_title, :string
    remove_column :invite_people, :job_url, :string
    add_reference :invite_people, :job, foreign_key: { on_delete: :nullify }
  end
end
