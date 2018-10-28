ActiveAdmin.register Invite do
  permit_params :reception, :ask_food, :rsvp, :food_type,
                people_attributes: %i[primary first_name last_name gender child coming _destroy id]
  decorate_with InviteDecorator

  index do
    selectable_column
    id_column
    column :name
    column :code
    column :rsvp
    column :created_at
    actions
  end

  form do |f|
    f.inputs 'Details' do
      f.input :reception
      f.input :ask_food
      f.input :rsvp
      f.input :food_type, collection: Invite.food_types, as: :radio
    end
    f.inputs 'People' do
      f.has_many :people, allow_destroy: true, new_record: true, heading: nil do |p|
        p.input :primary
        p.input :first_name
        p.input :last_name
        p.input :gender, collection: Invite::Person.genders, as: :radio
        p.input :child
        p.input :coming
      end
    end
    f.actions
  end
end
