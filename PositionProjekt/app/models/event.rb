class Event < ActiveRecord::Base

  belongs_to :position

  has_and_belongs_to_many :tags

  validates :EventName, presence: true

  validates :EventDescription, presence: true

  validate :EventDate_is_valid_datetime

  def EventDate_is_valid_datetime
    errors.add(:EventDate, 'must be a valid datetime') if ((DateTime.parse(:EventDate) rescue ArgumentError) == ArgumentError)
  end


end
