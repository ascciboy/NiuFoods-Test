module Api
  module V1
    class DevicesController < BaseController
      before_action :set_device, only: [:report]

      def index
        restaurant = Restaurant.find(params[:restaurant_id])

        render json: restaurant.devices.as_json(
          only: [:id, :name, :location, :status, :is_network_reachable, :last_connection_at]
        )
      end

      # POST /api/v1/devices/:id/report
      def report
        attrs = permitted_payload.merge(last_connection_at: Time.current)
        if @device.update(attrs)
          cache_current_state(attrs)
          @device.report_status(new_status: attrs[:status]) if attrs[:status]
          head :accepted
        else
          render json: { errors: @device.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_device
        @device = Device.find(params[:id])
      end

      def permitted_payload
        attrs = params[:device].is_a?(ActionController::Parameters) ? params[:device] : params
        attrs.permit(
          :status,
          :battery_level, :signal_strength, :network_latency_ms,
          :cpu_usage, :memory_usage, :temperature_celsius,
          :packet_loss_pct, :download_speed_mbps, :upload_speed_mbps,
          :connected_clients_count, :paper_status,
          :recording_status, :storage_available_gb
        )
      end

      def cache_current_state(attrs)
        return unless $redis_metrics&.respond_to?(:set)

        key = "device:#{@device.id}:state"
        $redis_metrics.set(key, attrs.to_json)
        $redis_metrics.expire(key, 180)
      end

    end
  end
end
