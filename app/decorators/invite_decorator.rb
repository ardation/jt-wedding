# frozen_string_literal: true

class InviteDecorator < ApplicationDecorator
  def name
    return "#{names_to_sentence} Whanau" if object.people.many?

    "#{primary_person.first_name} #{primary_person.last_name}".strip
  end

  def admin_name
    object.people.order(primary: :desc).pluck(:first_name).map(&:strip).to_sentence
  end

  protected

  def primary_person
    object.people.order(primary: :desc).first
  end

  def names_to_sentence
    object.people.order(primary: :desc).pluck(:last_name).uniq.map(&:strip).to_sentence
  end
end
