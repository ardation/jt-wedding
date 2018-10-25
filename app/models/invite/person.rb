class Invite::Person < ApplicationRecord
  belongs_to :invite
  validates :first_name, :last_name, presence: true
  enum gender: { male: 'male', female: 'female' }
end
