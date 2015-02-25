class Position < ActiveRecord::Base

  has_many :events

  validates :lng, presence: true
  validates :lat, presence: true
  validates :lng, numericality: true
  validates :lat, numericality: true

end
