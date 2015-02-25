class Tag < ActiveRecord::Base

  has_many :tag_on_events
  validates :name, presence: true


end
