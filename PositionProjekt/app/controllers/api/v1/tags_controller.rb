
module Api
  module V1
    class TagsController < ApplicationController

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
        respond_with Tag.create(params[:Tag])
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