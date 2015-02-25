class TagOnEvent < ActiveRecord::Base

  #has_and_belongs_to_many :events
  belongs_to :event
  #has_and_belongs_to_many :tags
  belongs_to :tag

  validates_presence_of :tag, :tag_id
  validates_associated :tag

  validates_presence_of :event, :event_id
  validates_associated :event


end
