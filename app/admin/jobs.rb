# frozen_string_literal: true

ActiveAdmin.register Job do
  permit_params :title, :url

  index do
    selectable_column
    id_column
    column :title
    column(:url) do |invite|
      link_to invite.url, invite.url, target: '_blank'
    end
    column :created_at
    actions
  end

  filter :title
  filter :url
  filter :created_at

  form do |f|
    f.inputs do
      f.input :title
      f.input :url
    end
    f.actions
  end

  show do
    columns do
      column span: 6 do
        panel 'Job Details' do
          attributes_table_for job do
            row :title
            row(:url) do |job|
              link_to job.url, job.url, target: '_blank'
            end
            row :created_at
            row :updated_at
          end
        end
        active_admin_comments
      end
      column span: 6 do
        panel 'People' do
          table_for job.people do
            column :first_name
            column :last_name
            column(:coming) do |person|
              status_tag(person.invite.rsvp? && person.coming?)
            end
            column(:coming_reception) do |person|
              status_tag(person.invite.rsvp? && person.coming_reception?)
            end
            column(:actions) do |person|
              link_to 'Show Invite', admin_invite_path(person.invite.id)
            end
          end
        end
      end
    end
  end
end
