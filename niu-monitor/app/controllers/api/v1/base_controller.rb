module Api
  module V1
    class BaseController < ApplicationController
      before_action :ensure_json_request

      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_request

      private

      def render_success(data:, status: :ok)
        render json: { success: true, data: data }, status: status
      end

      def render_error(message:, status: :unprocessable_entity)
        render json: { success: false, error: message }, status: status
      end


      def ensure_json_request
        return if request.headers["Content-Type"]&.include?("application/json")
        return if request.format.json?

        render json: { error: "Only JSON requests are allowed" }, status: :unsupported_media_type
      end

      def record_not_found(error)
        render json: { error: error.message }, status: :not_found
      end

      def unprocessable_request(error)
        render json: { error: error.record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
