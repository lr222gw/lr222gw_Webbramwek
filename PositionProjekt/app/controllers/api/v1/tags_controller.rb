
module Api
  module V1
    class TagsController < ApplicationController
      skip_before_filter  :verify_authenticity_token
      before_action do
        validateAPIKey(params[:apikey])
      end
      before_filter :authenticateJWT,:only => [:destroy, :create, :update]
      respond_to :json



      def index
        #tags = Tag.all
        tags = Tag.paginate(page: params[:page], per_page: 15)

        if(tags.total_entries > tags.current_page * tags.per_page)
          nextpage = "/api/v1/tags?page="+(tags.current_page + 1).to_s
        else
          nextpage = "null"
        end
        if(tags.current_page > 1)
          prevpage = "/api/v1/tags?page="+(tags.current_page - 1).to_s
        else
          prevpage = "null"
        end

        respond_with(tags) do |format|
          format.json {
              render :json => {
                         :current_page => tags.current_page,
                         :per_page => tags.per_page,
                         :total_entries => tags.total_entries,
                         :entries => tags,
                         :next_page => nextpage,
                         :prev_page => prevpage,
                         status: :ok
                     }
          }
        end
      end

      def show
        begin
          respond_with Tag.find(params[:id])
        rescue
          render :json => {:error => "Tag with id #{params[:id]} was not found", status: :bad_request}
        end

      end

      def create
        # Vi skapar en ny Tag, Vi berättar att vi ska skicka in "name" vilket vi får från parametern!
        begin
          @tag = Tag.new(tag_params)

          # Nu gäller det bara att spara ner den!
          @tag.save

          #När vi kör respond så berättar vi först vilket namespace vi ska responda till(?), sen anger vi vad som ska respondas: @tag <-DEN DEN! DEN! :D
          respond_with :api, :v1 , @tag
        rescue
          render :json => {:error => "Could not create tag", status: :bad_request}
        end

      end

      #Då Tag inte ägs av någon så begränsar jag att man bara kan skapa tags från apiet, inte ändra eller ta bort. Då jag inte kan begränsa det till en användare.
      def update
        begin
          tag = Tag.find(params[:id]);
          respond_with tag.update(tag_params)
        rescue
          render :json => {:error => "Tag with id #{params[:id]} was not found", status: :not_found}
        end

      end

      def destroy
        begin
          user = currentUser
          if(user.isAdmin?)
            respond_with Tag.destroy(params[:id])
          else
            render :json => {:error => "user is not permitted to remove tags", status: :unauthorized}
          end
        rescue
          render :json => {:error => "Tag with id #{params[:id]} was not found", status: :not_found}
        end

      end

      private
      def tag_params
        params.permit(:name)
      end

    end
  end
end

# def index_eventByTag
#   #tags = Tag.all
#   tags = Tag.paginate(page: params[:page], per_page: 15)
#
#   if(tags.total_entries > tags.current_page * tags.per_page)
#     nextpage = "/api/v1/tags?page="+(tags.current_page + 1).to_s
#   else
#     nextpage = "null"
#   end
#   if(tags.current_page > 1)
#     prevpage = "/api/v1/tags?page="+(tags.current_page - 1).to_s
#   else
#     prevpage = "null"
#   end
#
#   respond_with(tags) do |format|
#     format.json {
#       render :json => {
#                  :current_page => tags.current_page,
#                  :per_page => tags.per_page,
#                  :total_entries => tags.total_entries,
#                  :entries => tags,
#                  :next_page => nextpage,
#                  :prev_page => prevpage
#
#              }
#     }
#   end
# end