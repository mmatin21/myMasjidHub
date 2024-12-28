Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  resources :pledges
  resources :contacts
  resources :balances
  resources :prayers
  resources :donations
  resources :fundraisers
  devise_for :attendees
  resources :events
  resources :revenues
  devise_for :masjids, path: 'masjids', controllers: {
    sessions: "masjids/sessions",
    registrations: "masjids/registrations"
  }
  resources :expenses
  resources :months do
    collection do 
      get :months
    end
  end
  resources :options do
    collection do 
      get :pledges
    end
  end
  resources :masjids do
    resources :payouts, only: [:new, :create]
    member do
      get :connect_stripe
      get :open_stripe_dashboard
    end
  end
  resources :landing
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "landing#show"

end
