
module Api
  module V1
    class TagsController < ApplicationController
      skip_before_filter  :verify_authenticity_token
      before_action do
        validateAPIKey(params[:apikey])
        authenticateJWT
      end
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
                         :prev_page => prevpage

                     }
          }
        end
      end

      def show
        respond_with Tag.find(params[:id])
      end

      def create
        # Vi skapar en ny Tag, Vi berättar att vi ska skicka in "name" vilket vi får från parametern!
        @tag = Tag.new(name: params[:name])

        # Nu gäller det bara att spara ner den!
        @tag.save

        #När vi kör respond så berättar vi först vilket namespace vi ska responda till(?), sen anger vi vad som ska respondas: @tag <-DEN DEN! DEN! :D
        respond_with :api, :v1 , @tag
      end

      def update
        respond_with Tag.update(params[:id], params[:Tag])
      end

      def destroy
        respond_with Tag.destroy(params[:id])
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