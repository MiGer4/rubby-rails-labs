class Tagging < ApplicationRecord
  belongs_to :competition
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :competition_id }
end
