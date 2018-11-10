# frozen_string_literal: true

class Invite < ApplicationRecord
  has_many :people, dependent: :destroy
  has_one :primary_person,
          -> { where(primary: true) },
          class_name: 'Invite::Person'
  validates :code, presence: true
  before_validation :generate_code, on: :create
  enum food_type: { savoury: 'savoury', drink: 'drink', salad: 'salad', dessert: 'dessert', unable: 'unable' }
  accepts_nested_attributes_for :people, allow_destroy: true
  enum style: { email: 'email', physical: 'physical' }
  validates :email_address, presence: true, if: :email?
  validates :address_line_1, :address_line_2, :city, :country, presence: true, if: :physical?

  protected

  def generate_code
    self.code = SecureRandom.hex[1..5].upcase
  end
end
