class UsersController < ApplicationController

  def index

  end

  def login

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path
    else
      render :action => new
    end
  end

  private
  def user_params

      params.require(:user).permit(:email, :password)

  end

end
