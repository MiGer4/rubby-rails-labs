FactoryBot.define do
  factory :competition do
    title { "Chernivtsi Archery Championship" }
    start_date { Date.today + 5.days }
    end_date { Date.today + 10.days }
    prize_fund { 20000 }
    status { "upcoming" }
    location_name { "Chernivtsi" }

    association :user
  end
end
