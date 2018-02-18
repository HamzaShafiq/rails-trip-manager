Rails.application.routes.draw do
  resources :vehicles
  resources :users
  resources :trips do
    collection do
      get 'trips_summary'
    end
  end
  resources :companies
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
