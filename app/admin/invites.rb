# frozen_string_literal: true

ActiveAdmin.register Invite do
  batch_action :destroy, false
  permit_params :reception, :ask_food, :rsvp, :food_type, :phone, :style, :email_address,
                :street, :suburb, :city, :postal_code, :country,
                people_attributes: %i[
                  primary first_name last_name gender age coming coming_reception job_id admin_user_id _destroy id
                ]
  decorate_with InviteDecorator

  filter :people_first_name_cont, label: 'First Name'
  filter :people_last_name_cont, label: 'Last Name'
  filter :phone
  filter :email_address
  filter :email_address_blank, as: :boolean
  filter :style, as: :select, collection: Invite.styles, multiple: true, input_html: { size: 2 }
  filter :food_type, as: :select, collection: Invite.food_types, multiple: true, input_html: { size: 5 }
  filter :people_job_id, as: :select, collection: proc { Job.pluck(:title, :id) }, label: 'Job'
  filter :admin_user_id, as: :select, collection: proc { AdminUser.pluck(:email, :id) }, label: 'User'
  filter :invited_at_blank, as: :boolean
  filter :rsvp
  filter :reception

  scope :all, default: true
  scope(:received) { |scope| scope.where(invited_at: nil) }
  scope(:sent) { |scope| scope.where(rsvp: false).where.not(invited_at: nil) }
  scope(:responded) { |scope| scope.where(rsvp: true) }
  scope(:reception) { |scope| scope.where(reception: true) }
  scope(:ask_food) { |scope| scope.where(ask_food: true) }
  scope(:unassigned) { |scope| scope.where(admin_user_id: nil) }

  index do
    selectable_column
    id_column
    column :adult_first_names
    column :child_first_names
    column :last_names
    column(:code) do |invite|
      link_to invite.code, invite.invite_url, target: '_blank'
    end
    column :rsvp
    column :reception
    column :invited_at
    column :admin_user
    actions
  end

  csv do
    column :id
    column :short_name
    column :style
    column :code
    column :phone
    column :email_address
    column :street
    column :suburb
    column :city
    column :postal_code
    column :country
    column :food_type
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
            column :primary
            column(:coming) do |person|
              status_tag(person.invite.rsvp? && person.coming?)
            end
            column(:coming_reception) do |person|
              status_tag(person.invite.rsvp? && person.coming_reception?)
            end
            column :job
            column(:actions) do |person|
              link_to 'Make Primary', make_primary_admin_invite_path(person_id: person.id), method: :put
            end
          end
        end
        active_admin_comments
      end
      column span: 6 do
        panel 'Contact Details' do
          attributes_table_for invite do
            row :admin_user
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
            row :rsvp
            row :reception do |invite|
              status_tag(invite.reception?)
              link_to 'Toggle Reception', toggle_reception_admin_invite_path, method: :put, style: 'float: right'
            end
            row :ask_food do |invite|
              status_tag(invite.ask_food?)
              link_to 'Toggle Ask Food', toggle_ask_food_admin_invite_path, method: :put, style: 'float: right'
            end
            row :food_type if invite.ask_food?
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
      f.input :admin_user, collection: AdminUser.pluck(:email, :id), as: :select
      f.input :reception
      f.input :ask_food
      f.input :rsvp
      f.input :food_type, collection: Invite.food_types, as: :radio
      f.input :phone
      f.input :style, collection: Invite.styles, as: :radio
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
        p.input :coming_reception
        p.input :job
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

  member_action :toggle_reception, method: :put do
    resource.update(reception: !resource.reception)
    redirect_to resource_path, notice: 'Reception toggled!'
  end

  member_action :toggle_ask_food, method: :put do
    resource.update(ask_food: !resource.ask_food)
    redirect_to resource_path, notice: 'Ask Food toggled!'
  end

  member_action :make_primary, method: :put do
    return unless params[:person_id]

    resource.people.where.not(id: params[:person_id]).update(primary: false)
    resource.people.find(params[:person_id]).update(primary: true)
    redirect_to resource_path, notice: 'Person made primary!'
  end

  batch_action :send_invite do |ids|
    batch_action_collection.where(id: ids).find_each do |invite|
      next if invite.invited_at && invite.invited_at.to_date > 5.days.ago.to_date

      invite.send_invite
    end

    redirect_to collection_path, notice: 'Invites sent!'
  end

  batch_action :toggle_reception do |ids|
    batch_action_collection.where(id: ids).update_all('reception = NOT reception')

    redirect_to collection_path, notice: 'Toggled Reception!'
  end

  batch_action :toggle_ask_food do |ids|
    batch_action_collection.where(id: ids).update_all('ask_food = NOT ask_food')

    redirect_to collection_path, notice: 'Toggled Ask Food!'
  end

  batch_action :assign_to_me do |ids|
    batch_action_collection.where(id: ids).update_all(admin_user_id: current_admin_user.id)

    redirect_to collection_path, notice: 'Assigned invites to you!'
  end

  controller do
    def apply_filtering(chain)
      super(chain).distinct
    end
  end
end
