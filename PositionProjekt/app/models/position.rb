class Position < ActiveRecord::Base
  after_validation :fetchGeoLatLng
  has_many :events
  validates_uniqueness_of :longitude, :scope => [:latitude],
                          :message =>"longitude and latitude combo already Exists..."
  validates :name, presence: true
  #Tar bort validering PGA geocode hämtar denna data om den ej är satt vid sparning.
  #validates :longitude, presence: true
  #validates :latitude, presence: true

  geocoded_by :name

  def fetchGeoLatLng #Kollar om vi behöver hämta ut lng och lat, om de inte redan är satta.

    if(self.longitude.nil? || self.latitude.nil?)
      puts self.name
      geocode #Aktivaerar geocode på instansen av modellen! (?) <- Ser till att Geocode utför sitt jobb... i detta fall "geocoded_by :name"...
          # om man hade kört geocode direkt efter validering (after_validation) hade man skrivit  geocode såhär:  :geocode
    end
  end

  def as_json(options={})

    super(options.merge(:include => :events))

  end

end
