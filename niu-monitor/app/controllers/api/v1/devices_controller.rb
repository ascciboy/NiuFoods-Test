module Api
  module V1
    class DevicesController < BaseController
      before_action :set_device, only: [:update_status, :update_connection]

      # /api/v1/restaurants/:restaurant_id/devices
      def index
        restaurant = Restaurant.find(params[:restaurant_id])
        render json: restaurant.devices.select(:id, :name, :status, :critical, :last_connection_at, :location)
      end

      # PATCH /api/v1/devices/:id/status
      def update_status
        if params[:status].blank?
          return render json: { error: "status is required" }, status: :unprocessable_entity
        end

        unless Device::STATUSES.include?(params[:status])
          return render json: { error: "Invalid status", allowed: Device::STATUSES }, status: :unprocessable_entity
        end

        @device.report_status(
          new_status: params[:status],
          reported_at: params[:reported_at] || Time.current
        )

        render json: { message: "Status updated", device: @device }, status: :ok
      end

      # POST /api/v1/devices/:id/connection
      def update_connection
        @device.update(last_connection_at: Time.current)
        render json: { message: "Connection updated", device: @device }, status: :ok
      end

      private

      def set_device
        @device = Device.find(params[:id])
      end
    end
  end
end
