
module Api
  module V1

    class EventsController < ApplicationController
      respond_to :json

      def index
        events = Event.all.sort_by &:eventDate
        respond_with events.reverse
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

    class UsersController < ApplicationController
      respond_to :json

      def index
        respond_with User.all
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

    class TagsController < ApplicationController
      respond_to :json

      def index
        respond_with Tag.all
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