class InviteDecorator < ApplicationDecorator
  def name
    return "#{object.people.order(primary: :desc).pluck(:last_name).uniq.to_sentence} Whanau" if object.people.many?

    "#{object.primary_person.first_name} #{object.primary_person.last_name}".strip
  end
end
