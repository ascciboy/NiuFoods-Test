Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :restaurants, only: [:index, :show] do
        resources :devices, only: [:index]
      end

      resources :devices, only: [] do
        post "report", on: :member
      end

      resources :devices, only: [] do
        get "logs", to: "device_logs#index"
      end
      
    end
  end
end
