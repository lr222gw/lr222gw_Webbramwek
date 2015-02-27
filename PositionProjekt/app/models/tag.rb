class Tag < ActiveRecord::Base

  has_many :tag_on_events
  validates :name, presence: true

  def as_json(options = {})
    super(options.merge(:include => {:tag_on_events => {:include => :event }}))
  end

end
