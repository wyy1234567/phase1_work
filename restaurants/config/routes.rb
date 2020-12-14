Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/city_and_cuisines/:city_name/:api_key", to: "cities#search"
  get "/reviews/cuisine_id=:cuisine_id/city_id=:city_id/api_key=:api_key", to: "reviews#find_reviews"
end
