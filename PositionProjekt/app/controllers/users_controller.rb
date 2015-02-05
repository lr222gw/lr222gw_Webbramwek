class UsersController < ApplicationController

  def index

  end

  def login

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
