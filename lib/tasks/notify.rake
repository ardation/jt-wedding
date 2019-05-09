# frozen_string_literal: true

namespace :notify do
  desc 'Send Notification'
  task send: :environment do
    Invite.joins(:people).where(rsvp: true, invite_people: { coming: true }).distinct.find_each do |invite|
      puts "#{invite.primary_person.first_name.strip.capitalize} #{invite.phone}"
      invite.send_sms_notification
      sleep 5
    end
  end
end
