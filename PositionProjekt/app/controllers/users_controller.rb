class UsersController < ApplicationController

  before_action :currentUserIsAdmin, only: [:backendIndex]


  def index #Denna funktion verkar inte köras? hmmm
    currentUser

      puts currentUser
      #redirect_to(:action => :users_apps_path)

  end

  def backendloginindex

  end

  def backendIndex
    @users = User.all
  end

  def backendlogin
    user = User.find_by_email(params[:email])

    begin
    if user.isAdmin == true
      handleUserLogin true
    else
      flash[:notice] = "Du är ju inte admin, gå härifrån... din jävel :<"
      render :action => "backendloginindex"
    end
    rescue Exception
      flash[:notice] = "Du är ju inte admin, gå härifrån... din jävel :<"
      render :action => "backendloginindex"
    end


  end

  def logout
    session[:userid] = nil
    redirect_to(root_path)
  end

  def login
    handleUserLogin
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:userid] = @user.id
      redirect_to beforeIndex_path
    else
      render :action => "new"
      #denna fungerar men den ändrar sökvägen. det suger
      #new(@user) and return
      # redirect_to new_users_path, @user
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def handleUserLogin adminLogin = false
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      session[:userid] = @user.id
      if adminLogin == true
        #render json: {auth_token: create_token(@user.id)}
        redirect_to backendIndex_path #tillfälligt avstängd då jag testar JWT
      else
        #render json: {auth_token: create_token(@user.id)}
        redirect_to beforeIndex_path #users_apps_path #tillfälligt avstängd då jag testar JWT
      end

    else
      myStringWithErrors = ""

      if !@user
        myStringWithErrors = myStringWithErrors + "Emailen är inte registrerad"
        if params[:email] == ""
          myStringWithErrors = "Du måste ange din Email"
        end
      else
        if !@user.authenticate(params[:password])
          myStringWithErrors = myStringWithErrors + "Lösenordet stämde inte"

        end
      end


      flash[:notice] = myStringWithErrors
      render :action => "index"

    end
  end

end
