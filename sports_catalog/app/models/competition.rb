class Competition < ApplicationRecord
  has_and_belongs_to_many :sports
  has_and_belongs_to_many :teams

  enum :status, { upcoming: 0, ongoing: 1, completed: 2, cancelled: 3 }

  scope :upcoming_status, -> { where(status: "upcoming") }
  scope :completed_status, -> { where(status: "completed") }
  scope :big_prize, -> { where("prize_fund >= ?", 1000) }
  scope :starting_soon, -> { where(start_date: Date.today..(Date.today +  30.days)).order(:start_date) }


  validates :title, presence: true
end
