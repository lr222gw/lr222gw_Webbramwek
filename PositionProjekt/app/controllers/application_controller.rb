class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def createJWT(user)
    userID = user.id
    #userEmail = user.email

    render json: { token: create_token(userID)}

  end

  def authenticateJWT
    if(request.headers["Authorization"].present?)

      auth_header = request.headers["Authorization"].split(" ").last

      @token_payload = validate_token(auth_header) #auth_header är vårt Token som vi kontrollerar. vi vill fåtillbaka en payload
      if(!@token_payload) #om något är fel på payloaden

        render json: {error: "The proviced Token wasn't correct"}, status: :bad_request

      end

    else
      render json: {error: "Need to include the authroziation Header"}, status: :forbidden
    end
  end

  def create_token(userID)
    #Sköter JWT Encoding!
    #Skickar bara med UserID då jag inte vill kompromissa känslig data...

    secret = Rails.application.secrets.secret_key_base #En "Enviroment Variable" vad det nu kan tänkas innebära...
    payload = {user_id:userID, exp:2.hours.from_now} #All information vi vill skicka med
    JWT.encode(payload, secret, "HS512")  #encodar ihop hemligheten med vår payload och väljer hashningsalgoritm "HS512"

  end

  def validate_token(token)
    secret = Rails.application.secrets.secret_key_base

    payload = JWT.decode(token, secret, "HS512")
    if(payload[0][exp] >= time.now.to_i) # Kan sätta mer säkerhet angående om tiden är före token skapades. etc
      return payload
    else
      put "Token is too old."
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

    @currentUser = User.find(session[:userid]) if session[:userid] #||=

  end
  def isUserOnline

    if currentUser.nil?
      redirect_to root_path
    end

  end


end
