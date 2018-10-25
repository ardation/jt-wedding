class CreateInvitePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :invite_people do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.boolean :primary, default: false
      t.boolean :coming
      t.string :gender, default: 'male'
      t.boolean :child, default: false
      t.belongs_to :invite, null: false, foreign_key: { on_delete: :cascade }
      t.timestamps
    end
  end
end
