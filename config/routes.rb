Rails.application.routes.draw do
  resources :prayers
  resources :donations
  resources :fundraisers
  devise_for :attendees
  resources :events
  resources :revenues
  devise_for :masjids
  resources :expenses do
    collection do
      get :months
    end
  end
  resources :masjids
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "masjids#index"

end
