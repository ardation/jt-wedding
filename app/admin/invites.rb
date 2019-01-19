# frozen_string_literal: true

ActiveAdmin.register Invite do

  permit_params :reception, :ask_food, :rsvp, :food_type, :phone, :style, :email_address,
                :street, :suburb, :city, :postal_code, :country,
                people_attributes: %i[primary first_name last_name gender age coming job_title job_url _destroy id]
  decorate_with InviteDecorator

  index do
    selectable_column
    id_column
    column :admin_name
    column :code
    column :rsvp
    column :created_at
    actions
  end

  csv do
    column :id
    column :admin_name
    column :style
    column :code
    column :phone
    column :email_address
    column :street
    column :suburb
    column :city
    column :postal_code
    column :country
    column :created_at
  end

  show do
    columns do
      column span: 6 do
        panel 'People' do
          table_for invite.people do
            column :first_name
            column :last_name
            column :age
            column :coming
            column :primary
            column :job_title
            column :job_url
          end
        end
        active_admin_comments
      end
      column span: 6 do
        panel 'Details' do
          attributes_table_for invite do
            row :phone
            row :style
            row :food_type
            row :rsvp
            row :email_address
            row :street
            row :suburb
            row :city
            row :postal_code
            row :country
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :reception
      f.input :ask_food
      f.input :rsvp
      f.input :food_type, collection: Invite.food_types, as: :radio
      f.input :phone
      f.input :style
      f.input :email_address
      f.input :street
      f.input :suburb
      f.input :city
      f.input :postal_code
      f.input :country
    end
    f.inputs 'People' do
      f.has_many :people, allow_destroy: true, new_record: true, heading: nil do |p|
        p.input :primary
        p.input :first_name
        p.input :last_name
        p.input :gender, collection: Invite::Person.genders, as: :radio
        p.input :age, collection: Invite::Person.ages, as: :radio
        p.input :coming
        p.input :job_title
        p.input :job_url
      end
    end
    f.actions
  end
end
