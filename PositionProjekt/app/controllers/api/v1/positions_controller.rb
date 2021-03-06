module Api
  module V1
    class PositionsController < ApplicationController
      before_action do
        validateAPIKey(params[:apikey])
      end
      before_filter :authenticateJWT,:only => [:destroy, :create, :update]
      respond_to :json

      # TODO: förstörde jag något nu eller var det safe att ta bort denna? :)
      # class Position < ::Position
      #
      # end

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
                   },
                   status: :ok
          }
        end
      end

      def show
        begin
        position = Position.find(params[:id]);
        rescue
          render :json => {:error => "Position with ID #{params[:id]} was not found"}, status: :bad_request  and return
        end

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
                   },
                   status: :ok
          }


        end
      end

      def create
        begin
          @pos = Position.new
          if(!params[:latitude].nil? && !params[:longitude].nil? )
            @pos = Position.create(position_params)
            @pos.save
            #respond_with :api, :v1, @pos
          else
            @pos = Position.create(name: params[:name])
            @pos.save
            #respond_with :api, :v1, @pos <--- fungerar INTE!??!?!?

          end
          render json: {success: "The Position was created!", position: @pos}, status: :ok
        rescue
          render json: {error: "Could not create position!"}, status: :bad_request
        end

      end

      private

      def position_params
        params.permit(:name, :longitude, :latitude)
      end

      #Vill inte att användare ska kunna ändra på platser, de får skapa men ej ändra då en skapad plats tillhör alla.
      # def update
      #   respond_with Position.update(params[:id], params[:position])
      # end
      #
      # def destroy
      #   respond_with Position.destroy(params[:id])
      # end
    end
  end
end
