class App < ActiveRecord::Base
  require "base64"
  before_save :default_values # ser till at default_valuees körs...


  belongs_to :user          #Ser till att den tillhör en användare

  validates_presence_of :user, :user_id       #Ser till att vi kräver en användare för sparning av projektet...
  validates_associated :user

  validates :name,
            :presence => {message: "Din applikation måste ha ett namn"}
  validates_length_of :name, :minimum => 4, :maximum => 25


  def setApplicationKey isForDefault = false
    salt = BCrypt::Engine.generate_salt
    keyName = self.name + self.user.email
    #Gjorde om koden lite, Base64.strict_encode64 är bättre för URLer... (inga mellanrum eller konstiheter...)
    #key = BCrypt::Engine.hash_secret(keyName, salt)
    # urlFriendlyKey = CGI.escape(key)
    urlFriendlyKey = Base64.strict_encode64(keyName + salt)
    self.appKey = urlFriendlyKey
    if isForDefault != true
      self.save
    end
  end

  def default_values

    #metoden under ser till att ta fram en nyckel som är unik för användaren och dennes apps.. Den gör nyckeln URLvänlig också!
    setApplicationKey true

  end

end
