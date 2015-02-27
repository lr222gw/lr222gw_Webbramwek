class Event < ActiveRecord::Base

  belongs_to :position
  belongs_to :user

  has_many :tag_on_events

  validates_presence_of :user, :user_id       #Ser till att vi kräver en användare för sparning av projektet...
  validates_associated :user

  validates_presence_of :position, :position_id #Ser till att vi kräver en position för sparning av projektet...
  validates_associated :position



  validates :name, presence: true

  validates :desc, presence: true

  validates :eventDate, presence: true

  def as_json(options = {})

    super(options.merge(:methods => :userURL ))

  end

  include Rails.application.routes.url_helpers
  def userURL
    {:self => api_v1_event_path(self)}
  end

  # validate :EventDate_is_valid_datetime
  #
  # def EventDate_is_valid_datetime
  #   errors.add(:EventDate, 'must be a valid datetime') if ((DateTime.parse(:EventDate) rescue ArgumentError) == ArgumentError)
  # end


end
