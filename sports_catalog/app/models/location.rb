class Location < ApplicationRecord
  has_many :competitions, dependent: :destroy
end
