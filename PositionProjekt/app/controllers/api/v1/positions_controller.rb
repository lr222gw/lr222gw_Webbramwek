module Api
  module V1
    class PositionsController < ApplicationController
      before_action do
        validateAPIKey(params[:apikey])
      end
      respond_to :json

      class Position < ::Position

      end

      def index

        q = params[:query]


        puts Position.all.where("name LIKE :q", {:q => "%#{q}%"})
        position = Position.all.where("name LIKE :q", {:q => "%#{q}%"}).paginate(page: params[:page], per_page: 15)#all.sort_by &:eventDate

        #events.paginate(page: params[:page], per_page: 15)
        if(position.total_entries > position.current_page * position.per_page)
          nextpage = "/api/v1/position?page="+(position.current_page + 1).to_s
        else
          nextpage = "null"
        end
        if(position.current_page > 1)
          prevpage = "/api/v1/position?page="+(position.current_page - 1).to_s
        else
          prevpage = "null"
        end

        respond_with(position) do |format|

          format.json {
            render :json => {
                       :current_page => position.current_page,
                       :per_page => position.per_page,
                       :total_entries => position.total_entries,
                       :entries => position,
                       :next_page => nextpage,
                       :prev_page => prevpage

                   }
          }
        end
      end

      def show
        position = Position.find(params[:id]);
        if(params[:radius].nil?)
          radius = 20
        else
          radius = params[:radius].to_i
        end

        respond_with(position) do |format|

          format.json {
            render :json => {
                       :position => position,
                       :nearbys => position.nearbys(radius) #Tycker nearbys fungerar underligt.. men den "fungerar" :S
                   }
          }
        end
      end

      def create
        respond_with Position.create(params[:position])
      end

      def update
        respond_with Position.update(params[:id], params[:position])
      end

      def destroy
        respond_with Position.destroy(params[:id])
      end
    end
  end
end
