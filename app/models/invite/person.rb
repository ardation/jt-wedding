# frozen_string_literal: true

class Invite::Person < ApplicationRecord
  belongs_to :invite
  validates :first_name, :last_name, :gender, :age, presence: true
  enum gender: { male: 'male', female: 'female' }
  enum age: { adult: 'adult', child: 'child' }
  default_scope { order(primary: :desc, age: :desc) }
end
