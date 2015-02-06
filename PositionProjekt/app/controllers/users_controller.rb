class UsersController < ApplicationController

  before_action :currentUserIsAdmin, only: [:backendIndex]

  def index

  end

  def backendloginindex

  end

  def backendIndex
    @users = User.all
  end

  def backendlogin
    user = User.find_by_email(params[:email])
    if user.isAdmin == true
      handleUserLogin true
    else
      flash[:notice] = "Du är ju inte admin, gå härifrån... din jävel :<"
      render :action => "backendloginindex"
    end

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
      redirect_to users_apps_path
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
        redirect_to backendIndex_path
      else
        redirect_to users_apps_path
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
