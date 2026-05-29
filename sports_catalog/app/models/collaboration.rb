class Collaboration < ApplicationRecord
  belongs_to :competition
  belongs_to :user

  validates :user_id, uniqueness: { scope: :competition_id, message: "is already a collaborator" }
end
