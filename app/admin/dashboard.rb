# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }
  content title: proc { I18n.t('active_admin.dashboard') } do
    panel 'Invite Status' do
      requested = Invite.where(rsvp: false, invited_at: nil)
      sent = Invite.where(rsvp: false).where.not(invited_at: nil)
      responded = Invite.where(rsvp: true)
      h2 "#{pluralize requested.count, 'invite'} requested for #{pluralize requested.joins(:people).count, 'person'}"
      h2 "#{pluralize sent.count, 'invite'} sent for #{pluralize sent.joins(:people).count, 'person'}"
      h2 "#{pluralize responded.count, 'invite'} responded for #{pluralize responded.joins(:people).count, 'person'}"
    end

    AdminUser.find_each do |user|
      panel user.email do
        reception = Invite.joins(:people)
                          .where(admin_user: user,
                                 reception: true,
                                 invite_people: { age: 'adult', coming_reception: true })
                          .count
        h2 "#{pluralize(reception, 'person')} invited to the reception"
      end
    end
  end
end
