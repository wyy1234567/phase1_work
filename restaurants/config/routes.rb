Rails.application.routes.draw do
  resources :reviews
  resources :menus
  resources :restaurants
  resources :cuisines
  resources :cities
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
