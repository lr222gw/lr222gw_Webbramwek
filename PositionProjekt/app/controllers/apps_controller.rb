class AppsController < ApplicationController

  before_action :isUserOnline


  def index
    @user = currentUser
  end

  def new
    @app = App.new
  end

  def create
    app = App.new(app_params)

    app.user = currentUser

    if app.save
      redirect_to users_apps_path
    else
      render :action => new
    end

  end

  private
  def app_params
    params.require(:app).permit(:name)
  end

end
