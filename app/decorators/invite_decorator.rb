# frozen_string_literal: true

class InviteDecorator < ApplicationDecorator
  def first_names
    object.people.order(primary: :desc).pluck(:first_name).map(&:strip).map(&:titleize).to_sentence
  end

  def last_names
    object.people.order(primary: :desc).pluck(:last_name).map(&:strip).map(&:titleize).uniq.to_sentence
  end

  def name
    first_names
  end

  def short_name
    "#{first_names} #{single_family_name}".strip
  end

  def admin_name
    "#{first_names} #{last_names}".strip
  end

  def adult_first_names
    object.people.where(age: 'adult').order(primary: :desc).pluck(:first_name).map(&:strip).map(&:titleize).to_sentence
  end

  def child_first_names
    object.people.where(age: 'child').order(primary: :desc).pluck(:first_name).map(&:strip).map(&:titleize).to_sentence
  end

  def invite_url
    h.find_with_code_invite_url(default_url_options.merge(code: code))
  end

  def ceremony_ical(cal = Icalendar::Calendar.new)
    cal.event(&method(:ceremony_event))
    cal.to_ical
  end

  def reception_ical(cal = Icalendar::Calendar.new)
    cal.event(&method(:reception_event))
    cal.to_ical
  end

  protected

  def ceremony_event(event)
    event.dtstart = Icalendar::Values::DateTime.new DateTime.new(2019, 5, 11, 13, 0, 0), 'tzid' => 'Pacific/Auckland'
    event.dtend   = Icalendar::Values::DateTime.new DateTime.new(2019, 5, 11, 14, 0, 0), 'tzid' => 'Pacific/Auckland'
    event.summary = 'Jeanny & Tataihono\'s Wedding Ceremony'
    event.organizer = Icalendar::Values::CalAddress.new('mailto:no-reply@jeannyandtataihono.com')
    event.attendee = Icalendar::Values::CalAddress.new("mailto:#{email_address}", cn: name)
    event.description =
      "Come and celebrate what God brings together in marriage! Afternoon Tea to follow. #{invite_url}"
    event.url = invite_url
    event.location = 'Auckland Baptist Tabernacle, 429 Queen St, Auckland, 1010'
    event.geo = [-36.8575275, 174.7612384]
  end

  def reception_event(event)
    event.dtstart = Icalendar::Values::DateTime.new DateTime.new(2019, 5, 11, 17, 30, 0), 'tzid' => 'Pacific/Auckland'
    event.dtend   = Icalendar::Values::DateTime.new DateTime.new(2019, 5, 11, 22, 0, 0), 'tzid' => 'Pacific/Auckland'
    event.summary = 'Jeanny & Tataihono\'s Wedding Reception'
    event.organizer = Icalendar::Values::CalAddress.new('mailto:no-reply@jeannyandtataihono.com')
    event.attendee = Icalendar::Values::CalAddress.new("mailto:#{email_address}", cn: name)
    event.description = "Continue the celebration over a meal with us! #{invite_url}"
    event.url = invite_url
    event.location =
      'Grand Park Chinese Seafood Restaurant, Gate B, Alexandra Park Raceway, Green Lane West, Epsom, Auckland 1023'
    event.geo = [-36.8923332, 174.7739165]
  end

  def primary_person
    object.people.order(primary: :desc).first
  end

  def single_family_name
    last_names = object.people.order(primary: :desc).pluck(:last_name).map(&:strip).map(&:titleize).uniq
    last_names.length == 1 ? last_names.first : nil
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end
end
