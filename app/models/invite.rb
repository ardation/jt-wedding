class Invite < ApplicationRecord
  has_many :people, dependent: :destroy
  validates :code, presence: true
  before_validation :generate_code, on: :create
  enum food_type: { savoury: 'savoury', drink: 'drink', salad: 'salad', dessert: 'dessert' }

  protected

  def generate_code
    self.code = SecureRandom.hex[1..5].upcase
  end
end
