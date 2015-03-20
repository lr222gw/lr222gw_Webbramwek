
module Api
  module V1
    class EventsController < ApplicationController
      before_action do
        validateAPIKey(params[:apikey])

      end
      before_action :authenticateJWT, only: [:destroy, :updateWithExtra, :createWithExtra, :create, :update]
      #before_filter :authenticateJWT,only: [:destroy, :updateWithExtra, :create, :update]


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
                       :prev_page => prevpage,
                       :links => [
                           :url  => Rails.application.routes.url_helpers.api_v1_event_path(events)
                       ]

                   },
                   status: :ok
          }
        end
      end

      def show
        begin
          event = Event.find(params[:id]);
        rescue
          render :json => {:error => "Event with ID #{params[:id]} was not found"}, status: :bad_request and return
        end

        respond_with event
      end

      def create
        begin
          @event = Event.create(event_params)
          @event.user = User.find(getUserFromAuthorizationToken)
          begin
            @event.position = Position.find(params[:positionID])
          rescue
            render :json => {:error => "could not found Position for event"}, status: :bad_request
          end
          @event.save
          respond_with :api, :v1, @event
        rescue
          render :json => {:error => "Could not create Event"}, status: :bad_request
        end

      end

      def createWithExtra
        json_params = ActionController::Parameters.new( JSON.parse(request.body.read) )
        puts json_params["event"]
        if(Event.where(:user_id => getUserFromAuthorizationToken).exists?)

          @event = Event.new

          @event.name = json_params["event"]["name"]
          #puts json_params["event"]["name"]
          pos = Position.create("name" => json_params["event"]["position"]["name"])
          pos.save
          puts pos.errors.messages
          @event.position = pos;
          @event.desc = json_params["event"]["desc"]
          @event.eventDate = json_params["event"]["eventDate"]
          user = User.find(getUserFromAuthorizationToken);
          puts json_params["event"]["eventDate"]

          @event.user = user

          @event.save
          puts @event.errors.messages
          puts json_params["event"]["position"]["name"]

          tagArr = json_params["event"]["tags"].split(", ");
          puts tagArr


          tagArr.each do |tagg|

            if(Tag.where("name" => tagg).exists?)
              puts "hell SON"
              #puts TagOnEvent.where("name" === tagg, "event_id" === @event.id)[0]
              #@event.tag_on_events <<
              puts tagg
              existingTag = Tag.where("name" => tagg)[0]
              puts existingTag.name
              puts @event
              puts @event.id
              toe = TagOnEvent.create("tag" => existingTag, "tag_id" => existingTag.id, "event" => @event, "event_id" => @event.id)#TagOnEvent.where("name" === tagg, "event_id" === @event.id)[0]
              toe.save
              puts toe.errors.messages

            else
              tag = Tag.create("name" => tagg)
              tag.save
              toe = TagOnEvent.create("tag" => tag, "tag_id" => tag.id, "event" => @event, "event_id" => @event.id)
              @event.tag_on_events << toe
            end

          end

          @event.save

          #respond_with :api, :v1, @event
          render json: {success: "Created event!", event: @event}, status: :ok and return
        end

        render json: {error: "illegal user!"}, status: :forbidden and return
      end

      def updateWithExtra
        json_params = ActionController::Parameters.new( JSON.parse(request.body.read) )


        puts json_params["event"]
        if(Event.where(:user_id => getUserFromAuthorizationToken, :id => json_params["event"]["id"]).exists?)
          @event = Event.find(json_params["event"]["id"])
          puts "OVER HERE!"
          puts json_params["event"]
          puts @event.to_json
          puts "I AM A LIVE"

          @event.name = json_params["event"]["name"]
          #puts json_params["event"]["name"]
          puts @event.position
          pos = Position.find(@event.position.id)
          pos.name = json_params["event"]["position"]["name"]
          pos.save


          puts json_params["event"]["position"]["name"]
          puts @event.position
          @event.desc = json_params["event"]["desc"]
          #puts json_params["event"]["desc"]
          @event.eventDate = json_params["event"]["eventDate"]
          #puts json_params["event"]["eventDate"]

          @event.save

          arrWithTags = []
          tagArr = json_params["event"]["tags"].split(", ");
          puts tagArr



          #@event.tag_on_events = []
          #TagOnEvent.where("event_id" => @event.id).delete
          TagOnEvent.where("event_id" => @event.id).delete_all

          tagArr.each do |tagg|

            if(Tag.where("name" => tagg).exists?)
              puts "hell SON"
              #puts TagOnEvent.where("name" === tagg, "event_id" === @event.id)[0]
              #@event.tag_on_events <<
              puts tagg
              existingTag = Tag.where("name" => tagg)[0]
              puts existingTag.name
              puts @event
              puts @event.id
              toe = TagOnEvent.create("tag" => existingTag, "tag_id" => existingTag.id, "event" => @event, "event_id" => @event.id)#TagOnEvent.where("name" === tagg, "event_id" === @event.id)[0]
              toe.save
              puts toe.errors.messages
              #@event.tag_on_events << toe

              #toe = TagOnEvent.create("tag" => Tag.first, "tag_id" => Tag.first.id, "event" => Event.first, "event_id" => Event.first.id)

              #toe = TagOnEvent.create("tag" => tag, "tag_id" => tag.id, "event" => @event, "event_id" => @event.id)
              #toe.save

              puts "eat Soap"
              #tagOnEvent =
              #@event.tag_on_events << TagOnEvent.create("tag" => Tag.where("name" === "krona")[0], "tag_id" => Tag.where("name" === "krona")[0].id, "event" => Event.first, "event_id" => Event.first.id)
            else
              tag = Tag.create("name" => tagg)
              tag.save
              toe = TagOnEvent.create("tag" => tag, "tag_id" => tag.id, "event" => @event, "event_id" => @event.id)
              @event.tag_on_events << toe
            end

          end

          @event.save

          #respond_with :api, :v1, @event
          render json: {success: "Updated event!", event: @event}, status: :ok and return
        end

        render json: {error: "You dont have access to this event!"}, status: :forbidden and return
      end

      def update

        if(Event.where(:user_id => getUserFromAuthorizationToken, :id => params[:id]).exists?)
          @event = Event.find(params[:id])
          # if(!params[:name].nil?)
          #   @event.name = params[:name]
          # end
          # if(!params[:desc].nil?)
          #   @event.desc = params[:desc]
          # end
          # if(!params[:eventDate].nil?)
          #   @event.eventDate = params[:eventDate]
          # end
          @event.update(event_params)
          @event.save

          #respond_with :api, :v1, @event
          render json: {success: "Updated event!", event: @event}, status: :forbidden
        else
          render json: {error: "You dont have access to this event!"}, status: :forbidden
        end

      end

      def destroy
        puts "FAN "
        if(Event.where(:user_id => getUserFromAuthorizationToken, :id => params[:id]).exists?)

          @event = Event.find(params[:id])
          @event.destroy

          render json: {success: "Removed event!"}, status: :ok
        else

          render json: {error: "You dont have access to this event!", event: @event}, status: :forbidden
        end

      end

      private
      def event_params
        params.permit(:name, :desc, :eventDate)
      end

    end

  end
end