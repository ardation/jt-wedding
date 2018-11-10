# frozen_string_literal: true

class InviteDecorator < ApplicationDecorator
  def name
    return "#{names_to_sentence} Whanau" if object.people.many?

    "#{object.primary_person.first_name} #{object.primary_person.last_name}".strip
  end

  protected

  def names_to_sentence
    object.people.order(primary: :desc).pluck(:last_name).uniq.to_sentence
  end
end
