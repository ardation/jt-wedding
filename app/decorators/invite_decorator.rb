# frozen_string_literal: true

class InviteDecorator < ApplicationDecorator
  def name
    first_names
  end

  def admin_name
    "#{first_names} #{last_names}".strip
  end

  def invite_url
    h.find_with_code_invite_url(default_url_options.merge(code: code))
  end

  protected

  def primary_person
    object.people.order(primary: :desc).first
  end

  def first_names
    object.people.order(primary: :desc).pluck(:first_name).map(&:strip).map(&:capitalize).to_sentence
  end

  def last_names
    object.people.order(primary: :desc).pluck(:last_name).map(&:strip).map(&:capitalize).uniq.to_sentence
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end
end
