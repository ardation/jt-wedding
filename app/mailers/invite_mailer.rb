# frozen_string_literal: true

class InviteMailer < ApplicationMailer
  def invite(invite)
    @invite     = invite.decorate
    @invite_url = @invite.invite_url

    mail.attachments['ceremony.ics'] = { mime_type: 'text/calendar', content: @invite.ceremony_ical }

    if @invite.reception?
      mail.attachments['reception.ics'] = { mime_type: 'text/calendar', content: @invite.reception_ical }
    end

    mail(
      to: @invite.email_address,
      subject: "You're invited to Jeanny and Tataihono's Wedding on Saturday 11th May 2019!"
    )
  end
end
