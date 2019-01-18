# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }
  content title: proc { I18n.t('active_admin.dashboard') } do
    panel 'Invite Status' do
      h1 "#{pluralize Invite.count, 'invite'} requested for #{pluralize Invite::Person.count, 'person'}"
      h1 "#{pluralize Invite.where(rsvp: true).count, 'invite'} with RSVPs "\
         "for #{pluralize Invite.where(rsvp: true).joins(:people).count, 'person'}"
    end
  end
end
