Rails.application.routes.draw do
  get "leagues/index"
  get "leagues/show"
  get "leagues/new"
  get "leagues/create"
  root "home#index"

  # Routes for making picks
  post "picks/over/:team_id", to: "home#pick_over", as: "pick_over"
  post "picks/under/:team_id", to: "home#pick_under", as: "pick_under"

  # Reset route for testing
  post "reset_picks", to: "home#reset_picks", as: "reset_picks"
  post "reset_session", to: "home#reset_session", as: "reset_session"
  post "reset_all_data", to: "home#reset_all_data", as: "reset_all_data"

  # League routes
  resources :leagues, only: [ :index, :show, :new, :create ]
  post "join_league", to: "leagues#join_by_code", as: "join_league"

  # Pick routes for leagues
  post "leagues/:league_id/picks/over/:team_id", to: "leagues#pick_over", as: "league_pick_over"
  post "leagues/:league_id/picks/under/:team_id", to: "leagues#pick_under", as: "league_pick_under"


  # get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
