class Invite < ApplicationRecord
  has_many :people, dependent: :destroy
  has_one :primary_person,
          -> { where(primary: true) },
          class_name: 'Invite::Person'
  validates :code, presence: true
  before_validation :generate_code, on: :create
  enum food_type: { savoury: 'savoury', drink: 'drink', salad: 'salad', dessert: 'dessert', unable: 'unable' }
  accepts_nested_attributes_for :people

  protected

  def generate_code
    self.code = SecureRandom.hex[1..5].upcase
  end
end
