
module Api
 module V1

    class UsersController < ApplicationController
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

      # def create
      #   respond_with User.create(params[:user])
      # end

      # def update
      #   respond_with Event.update(params[:id], params[:user])
      # end

      # def destroy
      #   respond_with Event.destroy(params[:id])
      # end

    end
  end
end