class Job < ApplicationRecord
  validates :title, :url, presence: true
end
