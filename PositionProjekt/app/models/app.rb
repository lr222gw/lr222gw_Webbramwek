class App < ActiveRecord::Base

  before_save :default_values # ser till at default_valuees körs...


  belongs_to :user          #Ser till att den tillhör en användare

  validates_presence_of :user, :user_id       #Ser till att vi kräver en användare för sparning av projektet...
  validates_associated :user

  validates :name,
            :presence => {message: "Din applikation måste ha ett namn"}
  validates_length_of :name, :minimum => 4, :maximum => 25

  def SetApplicationKey isForDefault = false
    salt = BCrypt::Engine.generate_salt
    keyName = self.user.email + self.name
    key = BCrypt::Engine.hash_secret(keyName, salt)
    urlFriendlyKey = CGI.escape(key);
    self.appKey = urlFriendlyKey;
    if isForDefault != true
      self.save
    end
  end

  def default_values

    #metoden under ser till att ta fram en nyckel som är unik för användaren och dennes app.. Den gör nyckeln URLvänlig också!
    self.SetApplicationKey true

  end

end
