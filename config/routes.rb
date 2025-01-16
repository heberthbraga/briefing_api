Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "sessions/basic", to: "sessions#create_basic"
      post "registrations", to: "registrations#create"

      resources :users
    end
  end

  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
end
