module Api
  module V1
    class RestaurantsController < BaseController

      # GET /api/v1/restaurants
      def index
        render json: Restaurant.all.as_json(
          only: [:id, :name, :city, :status, :issues_count, :critical_issues_count, :last_report_at]
        )
      end

      # GET /api/v1/restaurants/:id
      def show
        restaurant = Restaurant.find(params[:id])

        render json: {
          id: restaurant.id,
          name: restaurant.name,
          city: restaurant.city,
          status: restaurant.status,
          issues_count: restaurant.issues_count,
          critical_issues_count: restaurant.critical_issues_count,
          last_report_at: restaurant.last_report_at,
          devices: restaurant.devices.map { |d|
            {
              id: d.id,
              name: d.name,
              status: d.status,
              location: d.location,
              offline: !d.is_network_reachable,
              last_connection_at: d.last_connection_at
            }
          }
        }
      end
    end
  end
end
