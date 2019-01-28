class Job < ApplicationRecord
  validates :title, :url, presence: true
  has_many :people, class_name: 'Invite::Person', dependent: :nullify
end
