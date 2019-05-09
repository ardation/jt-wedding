# frozen_string_literal: true

namespace :notify do
  desc 'Send Notification'
  task send: :environment do
    Invite.joins(:people).where(rsvp: true, invite_people: { coming: true }).distinct.find_each do |invite|
      sleep 5
      invite.send_sms_notification
    end
  end
end
