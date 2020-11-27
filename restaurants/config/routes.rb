Rails.application.routes.draw do
  resources :reviews
  resources :menus
  resources :restaurants
  resources :cuisines
  resources :cities
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/city_and_cuisines/:city_name/:api_key", to: "cities#search"
  get "/reviews/:cuisine_id/:city_id/:api_key", to: "reviews#find_reviews"
end
