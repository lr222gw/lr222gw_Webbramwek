class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session #:exception

  def validateAPIKey(apikey)
    if(apikey.nil?)
      #Kanske ska visa felmeddelande här istället?
      render json: {error: "Need to include API-key, API-key is missing..."}, status: :forbidden and return
      #redirect_to root_path
    end
    puts apikey
    if(App.where(:appKey => apikey).exists?)
      #Allting är som det ska och inget behöver avbrytas...
      # vi tillåter CORS...
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'GET'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    else
      render json: {error: "API-key is invalid..."}, status: :forbidden and return
    end
  end

  def allowPost()
    puts "SHIIIIIT"
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def createJWT(user)
    userID = user.id
    #userEmail = user.email

    render json: { token: create_token(userID)}

  end

  def authenticateJWT
    puts request.headers["bajs"]
    if(request.headers["Authorization"].present?)

      auth_header = request.headers["Authorization"].split(" ").last
      puts auth_header
      @token_payload = validate_token(auth_header) #auth_header är vårt Token som vi kontrollerar. vi vill fåtillbaka en payload
      if(!@token_payload) #om något är fel på payloaden
        puts "authenticateJWT INVALID TOKEN"
        render json: {error: "The provided Token wasn't correct"}, status: :bad_request

      end
      puts "authenticateJWT Inga fel, allt e chill"
      #headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS' #Tillåt alla methods...
    else
      puts "authenticateJWT NO authorization HEADER!!!!"
      puts request.headers["Authorization"]
      render json: {error: "Need to include the authroziation Header"}, status: :forbidden
    end
  end

  def create_token(userID)
    #Sköter JWT Encoding!
    #Skickar bara med UserID då jag inte vill kompromissa känslig data...

    secret = Rails.application.secrets.secret_key_base #En "Enviroment Variable" vad det nu kan tänkas innebära...
    payload = {user_id:userID, exp:2.hours.from_now} #All information vi vill skicka med

    token = JWT.encode(payload, secret, "HS512")  #encodar ihop hemligheten med vår payload och väljer hashningsalgoritm "HS512"
    session["token"] = token
    puts token
    token
  end

  def getUserFromAuthorizationToken
    puts "HÄR JÄVLA! 0"
    if(request.headers["Authorization"].present?)
      puts "HÄR JÄVLA! 1"
      token = request.headers["Authorization"].split(" ").last

      secret = Rails.application.secrets.secret_key_base
      begin
        puts "HÄR JÄVLA! 5"
        JWT.decode(token, secret, "HS512", {verify_expiration: false})
      rescue Exception
        puts "HÄR JÄVLA! 2"
        render json: {error: "The provided Token wasn't correct"}, status: :bad_request

      else

        payload = JWT.decode(token, secret, "HS512", {verify_expiration: false}) #JWT.decode("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VyX2lkIjoyMSwiZXhwIjoiMjAxNS0wMi0yOFQwOTozNDo0OS4xOTdaIn0.hR2yWysBuz3t4ft6dqZ7FYMhqo3F8M0DfuqSrDND-C48KbbUYYXpJztUkX4rzmomV9h0uXfxJ0bguVWUqLswNA", Rails.application.secrets.secret_key_base, "HS512")
        puts payload[0]["exp"].as_json
        if(payload[0]["exp"].to_datetime.to_i >= Time.now.to_i) # Kan sätta mer säkerhet angående om tiden är före token skapades. etc
          puts "HÄR JÄVLA! 4"
          return payload[0]["user_id"].to_i
        else
          puts "HÄR JÄVLA! 3"
          render json: {error: "The provided Token is to old"}, status: :not_acceptable
        end
      end
    end
    return false
  end

  def validate_token(token)
    puts token
    secret = Rails.application.secrets.secret_key_base
    begin
      JWT.decode(token, secret, "HS512", {verify_expiration: false})
    rescue Exception
      render json: {error: "The provided Token wasn't correct"}, status: :bad_request

    else

      payload = JWT.decode(token, secret, "HS512", {verify_expiration: false}) #JWT.decode("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VyX2lkIjoyMSwiZXhwIjoiMjAxNS0wMi0yOFQwOTozNDo0OS4xOTdaIn0.hR2yWysBuz3t4ft6dqZ7FYMhqo3F8M0DfuqSrDND-C48KbbUYYXpJztUkX4rzmomV9h0uXfxJ0bguVWUqLswNA", Rails.application.secrets.secret_key_base, "HS512")
      puts payload[0]["exp"].as_json
      if(payload[0]["exp"].to_datetime.to_i >= Time.now.to_i) # Kan sätta mer säkerhet angående om tiden är före token skapades. etc
        return payload
      else
        puts payload[0]["exp"].to_datetime.to_i
        puts Time.now.to_i
        puts "Token is too old."
        render json: {error: "The provided Token is to old"}, status: :not_acceptable
      end
      #Tidigare kod, som inte fungerade :S
      # payload = JWT.decode(token, secret, "HS512", {verify_expiration: true}) #JWT.decode("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VyX2lkIjoyMSwiZXhwIjoiMjAxNS0wMi0yOFQwOTozNDo0OS4xOTdaIn0.hR2yWysBuz3t4ft6dqZ7FYMhqo3F8M0DfuqSrDND-C48KbbUYYXpJztUkX4rzmomV9h0uXfxJ0bguVWUqLswNA", Rails.application.secrets.secret_key_base, "HS512")
      #
      # if(payload[0]["exp"] >= Time.now.to_i) # Kan sätta mer säkerhet angående om tiden är före token skapades. etc
      #   return payload
      # else
      #
      #
      #   puts "Token is too old."
      # end
    end
  end


  def currentUserIsAdmin
    isUserOnline
    @user = currentUser


    if @user.isAdmin == false
      redirect_to root_path
    end

  end

  def currentUser
    begin
      @currentUser = User.find(session[:userid]) if session[:userid] #||=
    rescue
      #redirect_to(:action => :logout) and return
    end


  end
  def isUserOnline

    if currentUser.nil?
      redirect_to root_path
    end

  end


end
