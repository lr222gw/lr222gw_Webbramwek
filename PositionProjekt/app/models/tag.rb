class Tag < ActiveRecord::Base

  has_many :events

  validates :Name, presence: true
  validates_presence_of :events, :event_id #Ser till att vi kräver en position för sparning av projektet...
  validates_associated :events

end
