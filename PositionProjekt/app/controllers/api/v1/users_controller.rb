
module Api
 module V1

    class UsersController < ApplicationController
      before_action do
        validateAPIKey(params[:apikey])
      end
      before_filter :authenticateJWT,:only => [:destroy, :update]
      respond_to :json

      def index
        users = User.all.paginate(page: params[:page], per_page: 15)

        if(users.total_entries > users.current_page * users.per_page)
          nextpage = "/api/v1/user?page="+(users.current_page + 1).to_s
        else
          nextpage = "null"
        end
        if(users.current_page > 1)
          prevpage = "/api/v1/user?page="+(users.current_page - 1).to_s
        else
          prevpage = "null"
        end

        respond_with(users) do |format|
          format.json {
            render :json => {
                       :current_page => users.current_page,
                       :per_page => users.per_page,
                       :total_entries => users.total_entries,
                       :entries => users,
                       :next_page => nextpage,
                       :prev_page => prevpage

                   }
          }
        end
      end

      def show
        respond_with User.find(params[:id])
      end

      def create
        #Kan ju inte ha krav på inloggning när man skapar användare ?? :S
        #user_id = getUserFromAuthorizationToken

        #if(user_id.respond_to?(:to_i))
          @user = User.new(email: params[:email],password: params[:password])
          @user.save
          respond_with :api, :v1, @user
        #end


      end

      def update
        user_id = getUserFromAuthorizationToken
        if(user_id.respond_to?(:to_i))

          @user = User.find(user_id)
          @user.email = params[:email]
          @user.password = params[:password]
          @user.save
          render json: {success: "The user was updated"}, status: :ok
        end

      end

      def destroy
        user_id = getUserFromAuthorizationToken
        if(user_id.respond_to?(:to_i))

          @user = User.find(user_id)
          @user.destroy
          @user.save
          render json: {success: "The user was removed"}, status: :ok
        end

      end

    end
  end
end