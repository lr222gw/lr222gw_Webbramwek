class AppsController < ApplicationController

  before_action :isUserOnline


  def index
    @user = currentUser
  end

  def edit
    @user = currentUser
    @app = App.find(params[:id]) # <- fungerar           #@user.apps.where(id: params[:id]) <-- gAlEt SkRaTt *FUNKAR INTE HAHAHAH ! ** :( (får rätt men kan ej anropa funktioner på den)

    #Ny säkerhets anordning så ingen byter på någon annans nyckel...
    if @user.apps.include? @app
      if @app
        @app.setApplicationKey
      end
    end
    render action: 'index'
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
