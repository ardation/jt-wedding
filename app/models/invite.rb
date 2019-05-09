# frozen_string_literal: true

class Invite < ApplicationRecord
  has_many :people, dependent: :destroy
  has_one :primary_person,
          -> { where(primary: true) },
          class_name: 'Invite::Person'
  validates :code, :phone, presence: true
  before_validation :generate_code, on: :create
  enum food_type: { savoury: 'savoury', drink: 'drink', salad: 'salad', dessert: 'dessert', unable: 'unable' }
  accepts_nested_attributes_for :people, allow_destroy: true
  enum style: { email: 'email', physical: 'physical' }
  validates :email_address, presence: true, if: :email?
  validates :street, :suburb, :city, :country, presence: true, if: :physical?
  after_commit :set_primary_person, on: :create
  belongs_to :admin_user, required: false

  def send_invite
    send_email_invite
    send_sms_invite
    update(invited_at: Time.current)
  end

  def send_email_invite
    return if rsvp? || !email?

    InviteMailer.invite(self).deliver_now
  end

  def send_sms_invite
    return if rsvp?

    SmsGatewayMeService.send_message(
      phone,
      "Hey #{primary_person.first_name.strip.capitalize}, Jeanny & Tataihono here. Your invite to our wedding "\
      "is on the way! Meanwhile you can RSVP by going to this link: #{decorate.invite_url}"
    )
  end

  def send_sms_notification
    SmsGatewayMeService.send_message(
      phone,
      "Hey #{primary_person.first_name.strip.capitalize}, Jeanny & Tataihono here. We are excited to see you at "\
      "our wedding. Here's a link to your invite with all the details: #{decorate.invite_url}"
    )
  end

  protected

  def generate_code
    self.code = SecureRandom.hex[1..5].upcase
  end

  def set_primary_person
    people.first.update(primary: true)
  end
end
