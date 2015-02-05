class UsersController < ApplicationController

  def index

  end

  def login
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      redirect_to index_path
    else
      render :action => 'login'
    end
  end

  def new#(user = nil)
    #if user.nil?
      @user = User.new
    # else
    #   @user = user;
    # end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path
    else
      render :action => 'new' #denna fungerar men den ändrar sökvägen. det suger
      #new(@user) and return
      # redirect_to new_users_path, @user
    end
  end

  private
  def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
