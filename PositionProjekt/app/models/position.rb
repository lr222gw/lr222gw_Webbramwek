class Position < ActiveRecord::Base

  has_many :events

  validates :name, presence: true
  validates :lng, presence: true
  validates :lat, presence: true

end
