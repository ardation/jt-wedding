class Invite::Person < ApplicationRecord
  belongs_to :invite
  validates :first_name, :last_name, :gender, presence: true
  enum gender: { male: 'male', female: 'female' }
  default_scope { order(primary: :desc, child: :asc) }
end
