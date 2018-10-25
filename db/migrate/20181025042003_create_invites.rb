class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.boolean :reception, default: false
      t.boolean :ask_food, default: true
      t.string :code, null: false, unique: true
      t.string :food_type

      t.timestamps
    end
  end
end
