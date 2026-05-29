require 'rails_helper'

RSpec.describe Competition, type: :model do
  let(:user) { create(:user) }

  describe "Validations" do
    it "is valid with valid attributes" do
      comp = build(:competition, user: user)
      expect(comp).to be_valid
    end

    it "is not valid without a title" do
      comp = build(:competition, title: nil, user: user)
      expect(comp).not_to be_valid
    end

    it "is not valid with negative prize_fund" do
      comp = build(:competition, prize_fund: -100, user: user)
      expect(comp).not_to be_valid
    end

    it "fails custom validation if end_date is before start_date" do
      comp = build(:competition, start_date: Date.today, end_date: Date.today - 1.day, user: user)
      expect(comp).not_to be_valid
      expect(comp.errors[:end_date]).to include("must be after or equal to the start date")
    end
  end

  describe "Scopes" do
    it "returns only upcoming competitions" do
      upcoming = create(:competition, status: "upcoming", user: user)
      completed = create(:competition, status: "completed", user: user)

      expect(Competition.upcoming_status).to include(upcoming)
      expect(Competition.upcoming_status).not_to include(completed)
    end
  end
end
