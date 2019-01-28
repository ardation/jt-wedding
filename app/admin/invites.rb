# frozen_string_literal: true

ActiveAdmin.register Invite do

  permit_params :reception, :ask_food, :rsvp, :food_type, :phone, :style, :email_address,
                :street, :suburb, :city, :postal_code, :country,
                people_attributes: %i[primary first_name last_name gender age coming job_title job_url _destroy id]
  decorate_with InviteDecorator

  filter :people_first_name_cont, label: 'First Name'
  filter :people_last_name_cont, label: 'Last Name'
  filter :phone
  filter :email_address
  filter :style, as: :check_boxes, collection: Invite.styles
  filter :food_type, as: :select, collection: Invite.food_types
  filter :people_job_title_cont, label: 'Job Title'

  scope :all, default: true
  scope(:pending) { |scope| scope.where(invited_at: nil) }
  scope(:invited) { |scope| scope.where.not(invited_at: nil) }
  scope(:reception) { |scope| scope.where(reception: true) }
  scope(:ask_food) { |scope| scope.where(ask_food: true) }
  scope(:received) { |scope| scope.where(rsvp: true) }

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
        panel 'Contact Details' do
          attributes_table_for invite do
            row :phone
            row :style
            if invite.email?
              row :email_address
            elsif invite.physical?
              row :street
              row :suburb
              row :city
              row :postal_code
              row :country
            end
          end
        end
        panel 'Invite Details' do
          attributes_table_for invite do
            row :food_type
            row :reception
            row :rsvp
            row :code do |invite|
              link_to invite.code, invite.invite_url, target: '_blank'
            end
            row :invited_at
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
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

  action_item :send_invite, only: :show do
    link_to 'Send Invite', send_invite_admin_invite_path(invite), method: :put unless invite.rsvp?
  end

  member_action :send_invite, method: :put do
    resource.send_invite
    redirect_to resource_path, notice: 'Invite sent!'
  end

  batch_action :send_invite do |ids|
    batch_action_collection.where(id: ids).find_each do |invite|
      next if invite.invited_at && invite.invited_at.to_date > 5.days.ago.to_date

      invite.send_invite
    end

    redirect_to collection_path, notice: 'Invites sent!'
  end
end
