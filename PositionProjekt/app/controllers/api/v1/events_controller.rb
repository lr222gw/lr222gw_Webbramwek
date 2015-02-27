
module Api
  module V1

    class EventsController < ApplicationController
      respond_to :json

      def index

        q = params[:query]
        
        puts Event.all.where("name LIKE :q", {:q => "%#{q}%"})
        events = Event.all.where("name LIKE :q", {:q => "%#{q}%"}).paginate(page: params[:page], per_page: 15).order("eventDate DESC")#all.sort_by &:eventDate

        #events.paginate(page: params[:page], per_page: 15)
        if(events.total_entries > events.current_page * events.per_page)
          nextpage = "/api/v1/events?page="+(events.current_page + 1).to_s
        else
          nextpage = "null"
        end
        if(events.current_page > 1)
          prevpage = "/api/v1/events?page="+(events.current_page - 1).to_s
        else
          prevpage = "null"
        end

        respond_with(events) do |format|

          format.json {
            render :json => {
                       :current_page => events.current_page,
                       :per_page => events.per_page,
                       :total_entries => events.total_entries,
                        :entries => events,
                       :next_page => nextpage,
                       :prev_page => prevpage

                   }
          }
        end
      end

      def show
        respond_with Event.find(params[:id])
      end

      def create
        respond_with Event.create(params[:event])
      end

      def update
        respond_with Event.update(params[:id], params[:event])
      end

      def destroy
        respond_with Event.destroy(params[:id])
      end

    end

  end
end