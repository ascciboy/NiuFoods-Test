module Api
  module V1
    class DeviceLogsController < BaseController

      def index
        device = Device.find(params[:device_id])

        logs = device.device_logs
                     .order(created_at: :desc)
                     .limit(params.fetch(:limit, 10))

        render json: logs.as_json(
          only: [
            :id,
            :previous_status, :new_status,
            :reason, :severity, :details,
            :metrics_snapshot,
            :reported_at, :processed_at, :created_at
          ]
        )
      end

    end
  end
end
