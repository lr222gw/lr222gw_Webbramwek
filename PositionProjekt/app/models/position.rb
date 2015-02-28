class Position < ActiveRecord::Base
  after_validation :geocode #Aktivaerar geocode på instansen av modellen! (?)
  has_many :events
  validates_uniqueness_of :longitude, :scope => [:latitude],
                          :message =>"longitude and latitude combo already Exists..."
  validates :name, presence: true
  #Tar bort validering PGA geocode hämtar denna data om den ej är satt vid sparning.
  #validates :longitude, presence: true
  #validates :latitude, presence: true

  geocoded_by :name


  def as_json(options={})

    super(options.merge(:include => :events))

  end

end
