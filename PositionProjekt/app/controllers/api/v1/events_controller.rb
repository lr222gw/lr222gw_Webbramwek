
module Api
  module V1
    class EventsController < ApplicationController
      before_action do
        validateAPIKey(params[:apikey])
      end
      before_filter :authenticateJWT,:only => [:destroy, :create, :update]


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
        event = Event.find(params[:id]);

        respond_with event
      end

      def create
        @event = Event.create(name: params[:name], eventDate: params[:eventDate], desc: params[:desc])
        @event.user = User.find(getUserFromAuthorizationToken)
        @event.position = Position.find(params[:positionID])
        @event.save
        respond_with :api, :v1, @event
      end

      def update

        if(Event.where(:user_id => getUserFromAuthorizationToken, :id => params[:id]).exists?)
          @event = Event.find(params[:id])
          if(!params[:name].nil?)
            @event.name = params[:name]
          end
          if(!params[:desc].nil?)
            @event.desc = params[:desc]
          end
          if(!params[:eventDate].nil?)
            @event.eventDate = params[:eventDate]
          end

          @event.save

          #respond_with :api, :v1, @event
          render json: {success: "Updated event!", event: @event}, status: :forbidden
        else
          render json: {error: "You dont have access to this event!"}, status: :forbidden
        end

      end

      def destroy
        if(Event.where(:user_id => getUserFromAuthorizationToken, :id => params[:id]).exists?)

          @event = Event.find(params[:id])
          @event.destroy

          render json: {success: "Removed event!"}, status: :forbidden
        else

          render json: {error: "You dont have access to this event!", event: @event}, status: :forbidden
        end

      end

    end

  end
end