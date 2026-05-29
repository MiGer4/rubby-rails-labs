class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :competitions, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :shared_competitions, through: :collaborations, source: :competition
end
