class Competition < ApplicationRecord
  has_and_belongs_to_many :sports
  has_and_belongs_to_many :teams

  enum :status, { upcoming: 0, ongoing: 1, completed: 2, cancelled: 3 }

  validates :title, presence: true
end
