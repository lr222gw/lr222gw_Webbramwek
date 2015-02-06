class AppsController < ApplicationController

  before_action :isUserOnline


  def index
    @user = currentUser
  end

  def edit
    @user = currentUser
    @app = App.find(params[:id]) # <- fungerar           #@user.apps.where(id: params[:id]) <-- gAlEt SkRaTt *FUNKAR INTE HAHAHAH ! ** :( (får rätt men kan ej anropa funktioner på den)
                                                          #^Kanske blev ett "ActiveRecord::relation" istället för App-objekt, här är resultat från Rails Terminalen: "#<ActiveRecord::Relation [#<User id: 13, email: "super@turbo.se", isAdmin: false, password_digest: "$2a$10$7VQdtl.Hy9dJ4BeqIkg.L.5kYK98nlSaHhxDh/6H4uX...", created_at: "2015-02-06 02:05:01", updated_at: "2015-02-06 02:05:01">]>"
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
