class Position < ActiveRecord::Base

  has_many :events

  validates :lng, presence: true
  validates :lat, presence: true

end
