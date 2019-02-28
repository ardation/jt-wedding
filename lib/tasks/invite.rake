namespace :invite do
  desc 'Resend Invites'
  task send: :environment do
    Invite.where(rsvp: false).where('invited_at <= ?', 5.days.ago).find_each(&:send_invite)
  end
end