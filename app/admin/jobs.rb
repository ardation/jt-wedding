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
end
