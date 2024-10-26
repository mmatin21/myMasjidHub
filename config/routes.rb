Rails.application.routes.draw do
  resources :balances
  resources :prayers
  resources :donations
  resources :fundraisers
  devise_for :attendees
  resources :events
  resources :revenues
  devise_for :masjids
  resources :expenses
  resources :months do
    collection do 
      get :months
    end
  end
  resources :masjids
  resources :landing
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "landing#show"

end
