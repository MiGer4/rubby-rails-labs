class Competition < ApplicationRecord
  has_and_belongs_to_many :sports
  has_and_belongs_to_many :teams
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  enum :status, { upcoming: 0, ongoing: 1, completed: 2, cancelled: 3 }

  scope :upcoming_status, -> { where(status: "upcoming") }
  scope :completed_status, -> { where(status: "completed") }
  scope :big_prize, -> { where("prize_fund >= ?", 1000) }
  scope :starting_soon, -> { where(start_date: Date.today..(Date.today +  30.days)).order(:start_date) }


  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :prize_fund, numericality: { greater_than_or_equal_to: 0 }
  validates :start_date, presence: true
  validate :end_date_must_be_after_start_date

  private def end_date_must_be_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after or equal to the start date")
    end
  end
end
