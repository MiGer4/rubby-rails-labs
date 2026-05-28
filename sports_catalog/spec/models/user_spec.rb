require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a valid email and password" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "deletes associated competitions when destroyed (dependent: :destroy)" do
    user = create(:user)
    create(:competition, user: user)

    expect { user.destroy }.to change { Competition.count }.by(-1)
  end
end
