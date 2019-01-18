# frozen_string_literal: true

class InviteDecorator < ApplicationDecorator
  def name
    first_names
  end

  def admin_name
    "#{first_names} #{last_names}".strip
  end

  protected

  def primary_person
    object.people.order(primary: :desc).first
  end

  def first_names
    object.people.order(primary: :desc).pluck(:first_name).map(&:strip).to_sentence
  end

  def last_names
    object.people.order(primary: :desc).pluck(:last_name).map(&:strip).map(&:titleize).uniq.to_sentence
  end
end
