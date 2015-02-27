
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

  end
end