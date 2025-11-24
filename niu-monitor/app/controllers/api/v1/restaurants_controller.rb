module Api
  module V1
    class RestaurantsController < BaseController
      def index
        render json: Restaurant.all.as_json(
          only: [:id, :name, :city, :status, :issues_count, :critical_issues_count, :last_report_at]
        )
      end

      def show
        restaurant = Restaurant.find(params[:id])
        render json: restaurant.as_json(
          include: {
            devices: { only: [:id, :name, :status, :critical, :last_connection_at, :location] }
          },
          except: [:created_at, :updated_at]
        )
      end
    end
  end
end
